defmodule Provision do
  alias Portal.{Repo, Account, Auth, Actor, Resource, Site, Group, Policy, Membership}
  alias Portal.EmailOTP.AuthProvider, as: EmailOTPAuthProvider
  alias Portal.AuthProvider
  require Logger
  import Ecto.Query

  # Helper for casting resource filters (matches Portal.Resource's private implementation)
  defp filter_changeset(struct, attrs) do
    struct
    |> Ecto.Changeset.cast(attrs, [:protocol, :ports])
    |> Ecto.Changeset.validate_required([:protocol])
  end

  # UUID Mapping handling
  defmodule UuidMapping do
    @mapping_file "provision-uuids.json"

    # Loads the mapping from file
    def load do
      mappings = case File.read(@mapping_file) do
        {:ok, content} ->
          case Jason.decode(content) do
            {:ok, mapping} -> mapping
            _ -> %{"accounts" => %{}}
          end

        _ -> %{"accounts" => %{}}
      end
      Process.put(:uuid_mappings, mappings)
      mappings
    end

    # Saves the current mapping (defaulting to the one in the process dictionary)
    def save(mapping \\ Process.get(:uuid_mappings)) do
      File.write!(@mapping_file, Jason.encode!(mapping))
    end

    # Retrieves the account-level mapping from a given mapping (or from Process)
    def get_account(mapping \\ Process.get(:uuid_mappings), account_slug) do
      get_in(mapping, ["accounts", account_slug]) || %{}
    end

    # Retrieves the entity mapping for a specific account and type
    def get_entities(mapping \\ Process.get(:uuid_mappings), account_slug, type) do
      get_in(mapping, ["accounts", account_slug, type]) || %{}
    end

    # Retrieves an entity mapping for a specific account, type and external_id
    def get_entity(mapping \\ Process.get(:uuid_mappings), account_slug, type, external_id) do
      get_in(mapping, ["accounts", account_slug, type, external_id])
    end

    # Updates (or creates) the account UUID mapping and stores it in the process dictionary.
    def update_account(account_slug, uuid) do
      mapping = Process.get(:uuid_mappings) || load()
      mapping = ensure_account_exists(mapping, account_slug)
      mapping = put_in(mapping, ["accounts", account_slug, "id"], uuid)
      Process.put(:uuid_mappings, mapping)
      mapping
    end

    # Ensures that the given account exists in the mapping.
    def ensure_account_exists(mapping, account_slug) do
      if not Map.has_key?(mapping["accounts"], account_slug) do
        put_in(mapping, ["accounts", account_slug], %{})
      else
        mapping
      end
    end

    # Updates (or creates) the mapping for entities of a given type for the account.
    def update_entities(account_slug, type, new_entries) do
      mapping = Process.get(:uuid_mappings) || load()
      mapping = ensure_account_exists(mapping, account_slug)
      current = get_entities(mapping, account_slug, type)
      mapping = put_in(mapping, ["accounts", account_slug, type], Map.merge(current, new_entries))
      Process.put(:uuid_mappings, mapping)
      mapping
    end

    # Removes an entire account from the mapping.
    def remove_account(account_slug) do
      mapping = Process.get(:uuid_mappings) || load()
      mapping = update_in(mapping, ["accounts"], fn accounts ->
        Map.delete(accounts, account_slug)
      end)
      Process.put(:uuid_mappings, mapping)
      mapping
    end

    # Removes a specific entity mapping for the account.
    def remove_entity(account_slug, type, key) do
      mapping = Process.get(:uuid_mappings) || load()
      mapping = update_in(mapping, ["accounts", account_slug, type], fn entities ->
        Map.delete(entities || %{}, key)
      end)
      Process.put(:uuid_mappings, mapping)
      mapping
    end
  end

  defp resolve_references(value) when is_map(value) do
    Enum.into(value, %{}, fn {k, v} -> {k, resolve_references(v)} end)
  end

  defp resolve_references(value) when is_list(value) do
    Enum.map(value, &resolve_references/1)
  end

  defp resolve_references(value) when is_binary(value) do
    Regex.replace(~r/\{env:([^}]+)\}/, value, fn _, var ->
      System.get_env(var) || raise "Environment variable #{var} not set"
    end)
  end

  defp resolve_references(value), do: value

  defp atomize_keys(map) when is_map(map) do
    Enum.into(map, %{}, fn {k, v} ->
      {
        if(is_binary(k), do: String.to_atom(k), else: k),
        if(is_map(v), do: atomize_keys(v), else: v)
      }
    end)
  end

  defp cleanup_account(uuid) do
    case Repo.get(Account, uuid) do
      nil ->
        :ok
      account ->
        Logger.info("Deleting removed account #{account.slug}")
        account |> Ecto.Changeset.change(%{deleted_at: DateTime.utc_now()}) |> Repo.update!()
    end
  end

  defp cleanup_actor(uuid, account) do
    case Repo.get_by(Actor, account_id: account.id, id: uuid) do
      nil ->
        :ok
      actor ->
        Logger.info("Deleting removed actor #{actor.name}")
        Repo.delete!(actor)
    end
  end

  defp cleanup_provider(uuid, account) do
    case Repo.get_by(AuthProvider, account_id: account.id, id: uuid) do
      nil ->
        :ok
      provider ->
        Logger.info("Deleting removed provider")
        Repo.delete!(provider)
    end
  end

  defp cleanup_site(uuid, account) do
    case Repo.get_by(Site, account_id: account.id, id: uuid) do
      nil ->
        :ok
      site ->
        Logger.info("Deleting removed site #{site.name}")
        Repo.delete!(site)
    end
  end

  defp cleanup_group(uuid, account) do
    case Repo.get_by(Group, account_id: account.id, id: uuid) do
      nil ->
        :ok
      group ->
        Logger.info("Deleting removed group #{group.name}")
        Repo.delete!(group)
    end
  end

  defp cleanup_resource(uuid, account) do
    case Repo.get_by(Resource, account_id: account.id, id: uuid) do
      nil ->
        :ok
      resource ->
        Logger.info("Deleting removed resource #{resource.name}")
        Repo.delete!(resource)
    end
  end

  defp cleanup_policy(uuid, account) do
    case Repo.get_by(Policy, account_id: account.id, id: uuid) do
      nil ->
        :ok
      policy ->
        Logger.info("Deleting removed policy #{policy.description}")
        Repo.delete!(policy)
    end
  end

  defp cleanup_entity_type(account_slug, entity_type, cleanup_fn, account) do
    # Get mapping for this entity type
    existing_entities = UuidMapping.get_entities(account_slug, entity_type)
    # Get current entities from account data
    current_entities = Process.get(:current_entities)
    # Determine which ones to remove
    removed_entity_ids = Map.keys(existing_entities) -- (current_entities[entity_type] || [])

    # Process each entity to remove
    Enum.each(removed_entity_ids, fn entity_id ->
      case existing_entities[entity_id] do
        nil -> :ok
        uuid ->
          cleanup_fn.(uuid, account)
          UuidMapping.remove_entity(account_slug, entity_type, entity_id)
      end
    end)
  end

  defp collect_current_entities(account_data) do
    %{
      "actors" => Map.keys(account_data["actors"] || %{}),
      "providers" => Map.keys(account_data["auth"] || %{}),
      "sites" => Map.keys(account_data["gatewayGroups"] || %{}),  # JSON key is still "gatewayGroups"
      # relay_groups removed - no longer tracked
      "groups" => Map.keys(account_data["groups"] || %{}) ++ ["everyone"],  # Renamed from actor_groups
      "resources" => Map.keys(account_data["resources"] || %{}),
      "policies" => Map.keys(account_data["policies"] || %{})
    }
  end

  defp create_temp_admin(account, _email_provider) do
    # Create temporary admin actor (no identity/token needed in new system)
    temp_admin_actor = %Actor{
      account_id: account.id,
      type: :account_admin_user,
      name: "Provisioning",
      email: "firezone-provision@localhost.local"
    } |> Repo.insert!()

    # Create synthetic subject without persisted token
    temp_admin_subject = %Auth.Subject{
      account: account,
      actor: temp_admin_actor,
      credential: %Auth.Credential{type: :portal_session, id: Ecto.UUID.generate()},
      expires_at: DateTime.utc_now() |> DateTime.add(1, :hour),
      context: %Auth.Context{
        type: :portal,
        remote_ip: {127, 0, 0, 1},
        user_agent: "provision/1"
      }
    }

    {temp_admin_subject, temp_admin_actor}
  end

  defp cleanup_temp_admin(temp_admin_actor) do
    Logger.info("Cleaning up temporary admin actor")
    Repo.delete!(temp_admin_actor)
  end

  def provision() do
    Logger.info("Starting provisioning")

    # Load desired state
    json_file = "provision-state.json"
    {:ok, raw_json} = File.read(json_file)
    {:ok, %{"accounts" => accounts}} = Jason.decode(raw_json)
    accounts = resolve_references(accounts)

    # Load existing UUID mappings into the process dictionary.
    UuidMapping.load()

    # Clean up removed accounts first
    current_account_slugs = Map.keys(accounts)
    existing_accounts = Map.keys(Process.get(:uuid_mappings)["accounts"])
    removed_accounts = existing_accounts -- current_account_slugs

    Enum.each(removed_accounts, fn slug ->
      if uuid = get_in(Process.get(:uuid_mappings), ["accounts", slug, "id"]) do
        cleanup_account(uuid)
        # Remove the account from the UUID mapping.
        UuidMapping.remove_account(slug)
      end
    end)

    multi = Enum.reduce(accounts, Ecto.Multi.new(), fn {slug, account_data}, multi ->
      account_attrs = atomize_keys(%{
        name: account_data["name"],
        slug: slug,
        features: Map.get(account_data, "features", %{}),
        metadata: Map.get(account_data, "metadata", %{}),
        limits: Map.get(account_data, "limits", %{})
      })

      multi = multi
        |> Ecto.Multi.run({:account, slug}, fn repo, _changes ->
          case Repo.get_by(Account, slug: slug) do
            nil ->
              Logger.info("Creating new account #{slug}")
              # legal_name defaults to name if not provided
              account_attrs_with_legal = Map.put_new(account_attrs, :legal_name, account_attrs[:name])
              account = %Account{}
                |> Ecto.Changeset.cast(account_attrs_with_legal, [:name, :slug, :legal_name])
                |> Ecto.Changeset.cast_embed(:features)
                |> Ecto.Changeset.cast_embed(:limits)
                |> Ecto.Changeset.cast_embed(:metadata)
                |> repo.insert!()

              Logger.info("Creating internet site")
              internet_site = %Site{
                account_id: account.id,
                name: "Internet",
                managed_by: :system
              } |> repo.insert!()

              Logger.info("Creating internet resource")
              _internet_resource = %Resource{
                account_id: account.id,
                name: "Internet",
                type: :internet,
                site_id: internet_site.id
              } |> repo.insert!()

              # Create default Userpass auth provider for new accounts
              Logger.info("Creating default Userpass auth provider")
              provider_id = Ecto.UUID.generate()
              repo.insert!(%AuthProvider{
                id: provider_id,
                account_id: account.id,
                type: :userpass
              })
              repo.insert!(%Portal.Userpass.AuthProvider{
                id: provider_id,
                account_id: account.id,
                name: "Username & Password"
              })

              # Store mapping of slug to UUID
              UuidMapping.update_account(slug, account.id)
              {:ok, {:new, account}}
            acc ->
              Logger.info("Updating existing account #{slug}")
              updated_acc = acc |> Ecto.Changeset.change(account_attrs) |> repo.update!()
              {:ok, {:existing, updated_acc}}
          end
        end)
        |> Ecto.Multi.run({:everyone_group, slug}, fn repo, changes ->
          case Map.get(changes, {:account, slug}) do
            {:new, account} ->
              Logger.info("Creating everyone group for new account")
              actor_group = %Group{
                account_id: account.id,
                name: "Everyone",
                type: :managed
              } |> repo.insert!()
              UuidMapping.update_entities(slug, "groups", %{"everyone" => actor_group.id})
              {:ok, actor_group}
            {:existing, _account} ->
              {:ok, :skipped}
          end
        end)
        |> Ecto.Multi.run({:email_provider, slug}, fn _repo, changes ->
          case Map.get(changes, {:account, slug}) do
            {:new, _account} ->
              # For new accounts, email provider should not exist yet
              # It will be created if needed, but for now we just return nil
              {:ok, nil}
            {:existing, account} ->
              # Query for existing email provider
              result = from(p in EmailOTPAuthProvider,
                join: base in AuthProvider, on: base.id == p.id,
                where: base.account_id == ^account.id
              ) |> Repo.one()
              {:ok, result}
          end
        end)
        |> Ecto.Multi.run({:temp_admin, slug}, fn _repo, changes ->
          {_, account} = changes[{:account, slug}]
          email_provider = changes[{:email_provider, slug}]
          {:ok, create_temp_admin(account, email_provider)}
        end)

      # Clean up removed entities for this account
      multi = multi
        |> Ecto.Multi.run({:cleanup_entities, slug}, fn _repo, changes ->
          {_, account} = changes[{:account, slug}]

          # Store current entities in process dictionary for our helper function
          current_entities = collect_current_entities(account_data)
          Process.put(:current_entities, current_entities)

          # Define entity types and their cleanup functions
          entity_types = [
            {"actors", &cleanup_actor/2},
            {"providers", &cleanup_provider/2},
            {"sites", &cleanup_site/2},        # Changed from gateway_groups
            # relay_groups removed - no longer persisted
            {"groups", &cleanup_group/2},      # Changed from actor_groups
            {"resources", &cleanup_resource/2},
            {"policies", &cleanup_policy/2}
          ]

          # Clean up each entity type
          Enum.each(entity_types, fn {entity_type, cleanup_fn} ->
            cleanup_entity_type(slug, entity_type, cleanup_fn, account)
          end)

          {:ok, :cleaned}
        end)

      # Create or update actors
      multi = Enum.reduce(account_data["actors"] || %{}, multi, fn {external_id, actor_data}, multi ->
        Ecto.Multi.run(multi, {:actor, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]
          uuid = UuidMapping.get_entity(slug, "actors", external_id)
          case uuid && Repo.get_by(Actor, account_id: account.id, id: uuid) do
            nil ->
              Logger.info("Creating new actor #{actor_data["name"]}")
              actor_type = String.to_existing_atom(actor_data["type"])
              # service_account and api_client must NOT have email (constraint requirement)
              # account_user and account_admin_user MUST have email
              actor_attrs = case actor_type do
                type when type in [:service_account, :api_client] ->
                  %{account_id: account.id, type: type, name: actor_data["name"]}
                _ ->
                  %{account_id: account.id, type: actor_type, name: actor_data["name"], email: actor_data["email"]}
              end
              actor = struct(Actor, actor_attrs) |> repo.insert!()
              UuidMapping.update_entities(slug, "actors", %{external_id => actor.id})
              {:ok, actor}
            existing_actor ->
              Logger.info("Updating existing actor #{actor_data["name"]}")
              # Only set email for account_user and account_admin_user types
              update_attrs = case existing_actor.type do
                type when type in [:service_account, :api_client] ->
                  %{name: actor_data["name"]}
                _ ->
                  %{name: actor_data["name"], email: actor_data["email"]}
              end
              updated_actor = existing_actor
                |> Ecto.Changeset.change(update_attrs)
                |> repo.update!()
              {:ok, updated_actor}
          end
        end)
      end)

      # Provider management through JSON config is deprecated in the new Portal architecture
      # Providers should be created through the web interface or via direct database operations
      multi = Enum.reduce(account_data["auth"] || %{}, multi, fn {external_id, provider_data}, multi ->
        Ecto.Multi.run(multi, {:provider, slug, external_id}, fn _repo, changes ->
          {_, account} = changes[{:account, slug}]
          uuid = UuidMapping.get_entity(slug, "providers", external_id)
          case uuid && Repo.get_by(AuthProvider, account_id: account.id, id: uuid) do
            nil ->
              Logger.warning("Provider #{provider_data["name"]} not found. Provider creation through provision-state.json is no longer supported. Please create providers through the web interface.")
              {:ok, nil}
            existing ->
              Logger.info("Found existing provider #{external_id}")
              {:ok, existing}
          end
        end)
      end)

      # Create or update sites (formerly gateway groups)
      # Note: JSON key is still "gatewayGroups" for backward compatibility
      multi = Enum.reduce(account_data["gatewayGroups"] || %{}, multi, fn {external_id, site_data}, multi ->
        Ecto.Multi.run(multi, {:site, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]
          uuid = UuidMapping.get_entity(slug, "sites", external_id)
          case uuid && Repo.get_by(Site, account_id: account.id, id: uuid) do
            nil ->
              Logger.info("Creating new site #{site_data["name"]}")
              site = %Site{
                account_id: account.id,
                name: site_data["name"],
                managed_by: :account
              } |> repo.insert!()
              UuidMapping.update_entities(slug, "sites", %{external_id => site.id})
              {:ok, site}
            existing ->
              # Nothing to update for sites
              {:ok, existing}
          end
        end)
      end)

      # Relay groups are now deprecated (ephemeral in new Firezone)
      # Log warning if any are defined in the JSON
      multi = if map_size(account_data["relayGroups"] || %{}) > 0 do
        Logger.warning("Relay groups in provision-state.json are deprecated and will be ignored. Relays are now global and ephemeral.")
        multi
      else
        multi
      end

      # Create or update actor_groups
      multi = Enum.reduce(account_data["groups"] || %{}, multi, fn {external_id, actor_group_data}, multi ->
        Ecto.Multi.run(multi, {:group, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]
          uuid = UuidMapping.get_entity(slug, "groups", external_id)
          case uuid && Repo.get_by(Group, account_id: account.id, id: uuid) do
            nil ->
              Logger.info("Creating new group #{actor_group_data["name"]}")
              group = %Group{
                account_id: account.id,
                name: actor_group_data["name"],
                type: :static
              } |> repo.insert!()
              UuidMapping.update_entities(slug, "groups", %{external_id => group.id})
              {:ok, group}
            existing ->
              {:ok, existing}
          end
        end)
        |> Ecto.Multi.run({:group_members, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]
          group_uuid = UuidMapping.get_entity(slug, "groups", external_id)

          memberships =
            from(m in Membership, where: m.group_id == ^group_uuid)
            |> repo.all()

          existing_members = Enum.map(memberships, fn membership -> membership.actor_id end)
          desired_members = Enum.map(actor_group_data["members"] || [], fn member ->
            uuid = UuidMapping.get_entity(slug, "actors", member)
            if uuid == nil do
              raise "Cannot find provisioned actor #{member} to add to group"
            end
            uuid
          end)

          missing_members = desired_members -- existing_members
          untracked_members = existing_members -- desired_members

          Logger.info("Updating members for group #{external_id}")
          Enum.each(missing_members || [], fn actor_uuid ->
            Logger.info("Adding member #{external_id}")
            %Membership{
              account_id: account.id,
              group_id: group_uuid,
              actor_id: actor_uuid
            }
            |> repo.insert!()
          end)

          if actor_group_data["forceMembers"] == true do
            # Remove untracked members
            if untracked_members != [] do
              from(m in Membership,
                where: m.group_id == ^group_uuid and m.actor_id in ^untracked_members
              )
              |> repo.delete_all()
            end
          end

          {:ok, nil}
        end)
      end)

      # Create or update resources
      multi = Enum.reduce(account_data["resources"] || %{}, multi, fn {external_id, resource_data}, multi ->
        Ecto.Multi.run(multi, {:resource, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]

          # Convert gatewayGroups array to single site_id (take first element)
          gateway_groups = resource_data["gatewayGroups"] || []
          site_id = case gateway_groups do
            [] ->
              Logger.warning("Resource #{resource_data["name"]} has no gateway groups, skipping")
              nil
            [first | rest] ->
              if length(rest) > 0 do
                Logger.warning("Resource #{resource_data["name"]} has multiple gateway groups, using first: #{first}")
              end
              UuidMapping.get_entity(slug, "sites", first)
          end

          resource_attrs = %{
            type: String.to_existing_atom(resource_data["type"]),
            name: resource_data["name"],
            address: resource_data["address"],
            address_description: resource_data["address_description"],
            site_id: site_id,
            filters: Enum.map(resource_data["filters"] || [], fn filter ->
              # Convert port integers to strings as required by Portal.Types.Int4Range
              ports = Enum.map(filter["ports"] || [], fn port ->
                if is_integer(port), do: Integer.to_string(port), else: port
              end)
              %{
                ports: ports,
                protocol: String.to_existing_atom(filter["protocol"])
              }
            end)
          }

          uuid = UuidMapping.get_entity(slug, "resources", external_id)
          case uuid && Repo.get_by(Resource, account_id: account.id, id: uuid) do
            nil ->
              Logger.info("Creating new resource #{resource_data["name"]}")
              resource = %Resource{account_id: account.id}
                |> Ecto.Changeset.cast(resource_attrs, [:type, :name, :address, :address_description, :site_id])
                |> Ecto.Changeset.cast_embed(:filters, with: &filter_changeset/2)
                |> Resource.changeset()
                |> repo.insert!()
              UuidMapping.update_entities(slug, "resources", %{external_id => resource.id})
              {:ok, resource}
            existing ->
              Logger.info("Updating existing resource #{resource_data["name"]}")
              updated_resource = existing
                |> Ecto.Changeset.cast(resource_attrs, [:type, :name, :address, :address_description, :site_id])
                |> Ecto.Changeset.cast_embed(:filters, with: &filter_changeset/2)
                |> Resource.changeset()
                |> repo.update!()
              {:ok, updated_resource}
          end
        end)
      end)

      # Create or update policies
      multi = Enum.reduce(account_data["policies"] || %{}, multi, fn {external_id, policy_data}, multi ->
        Ecto.Multi.run(multi, {:policy, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]

          policy_attrs = %{
            description: policy_data["description"],
            group_id: UuidMapping.get_entity(slug, "groups", policy_data["group"]),
            resource_id: UuidMapping.get_entity(slug, "resources", policy_data["resource"])
          }

          uuid = UuidMapping.get_entity(slug, "policies", external_id)
          case uuid && Repo.get_by(Policy, account_id: account.id, id: uuid) do
            nil ->
              Logger.info("Creating new policy #{policy_data["name"]}")
              policy = %Policy{account_id: account.id}
                |> Ecto.Changeset.cast(policy_attrs, [:description, :group_id, :resource_id])
                |> repo.insert!()
              UuidMapping.update_entities(slug, "policies", %{external_id => policy.id})
              {:ok, policy}
            existing ->
              Logger.info("Updating existing policy #{policy_data["name"]}")
              updated_policy = existing
                |> Ecto.Changeset.cast(policy_attrs, [:description, :group_id, :resource_id])
                |> repo.update!()
              {:ok, updated_policy}
          end
        end)
      end)

      # Clean up temporary admin after all operations
      multi |> Ecto.Multi.run({:cleanup_temp_admin, slug}, fn _repo, changes ->
        {_temp_admin_subject, temp_admin_actor} = changes[{:temp_admin, slug}]
        cleanup_temp_admin(temp_admin_actor)
        {:ok, :cleaned}
      end)
    end)
    |> Ecto.Multi.run({:save_state}, fn _repo, _changes ->
      # Save all UUID mappings to disk.
      UuidMapping.save()
      {:ok, :saved}
    end)

    case Repo.transaction(multi) do
      {:ok, _result} ->
        Logger.info("Provisioning completed successfully")
      {:error, step, reason, _changes} ->
        Logger.error("Provisioning failed at step #{inspect(step)}, no changes were applied: #{inspect(reason)}")
    end
  end
end

Provision.provision()

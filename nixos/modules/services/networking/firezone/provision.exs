defmodule Provision do
  alias Domain.{Repo, Accounts, Auth, Actors, Resources, Tokens, Gateways, Relays, Policies}
  require Logger

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
    case Accounts.fetch_account_by_id_or_slug(uuid) do
      {:ok, value} when value.deleted_at == nil ->
        Logger.info("Deleting removed account #{value.slug}")
        value |> Ecto.Changeset.change(%{ deleted_at: DateTime.utc_now() }) |> Repo.update!()
      _ -> :ok
    end
  end

  defp cleanup_actor(uuid, subject) do
    case Actors.fetch_actor_by_id(uuid, subject) do
      {:ok, value} ->
        Logger.info("Deleting removed actor #{value.name}")
        {:ok, _} = Actors.delete_actor(value, subject)
      _ -> :ok
    end
  end

  defp cleanup_provider(uuid, subject) do
    case Auth.fetch_provider_by_id(uuid, subject) do
      {:ok, value} ->
        Logger.info("Deleting removed provider #{value.name}")
        {:ok, _} = Auth.delete_provider(value, subject)
      _ -> :ok
    end
  end

  defp cleanup_gateway_group(uuid, subject) do
    case Gateways.fetch_group_by_id(uuid, subject) do
      {:ok, value} ->
        Logger.info("Deleting removed gateway group #{value.name}")
        {:ok, _} = Gateways.delete_group(value, subject)
      _ -> :ok
    end
  end

  defp cleanup_relay_group(uuid, subject) do
    case Relays.fetch_group_by_id(uuid, subject) do
      {:ok, value} ->
        Logger.info("Deleting removed relay group #{value.name}")
        {:ok, _} = Relays.delete_group(value, subject)
      _ -> :ok
    end
  end

  defp cleanup_actor_group(uuid, subject) do
    case Actors.fetch_group_by_id(uuid, subject) do
      {:ok, value} ->
        Logger.info("Deleting removed actor group #{value.name}")
        {:ok, _} = Actors.delete_group(value, subject)
      _ -> :ok
    end
  end

  # Fetch resource by uuid, but follow the chain of replacements if any
  defp fetch_resource(uuid, subject) do
    case Resources.fetch_resource_by_id(uuid, subject) do
      {:ok, resource} when resource.replaced_by_resource_id != nil -> fetch_resource(resource.replaced_by_resource_id, subject)
      v -> v
    end
  end

  defp cleanup_resource(uuid, subject) do
    case fetch_resource(uuid, subject) do
      {:ok, value} when value.deleted_at == nil ->
        Logger.info("Deleting removed resource #{value.name}")
        {:ok, _} = Resources.delete_resource(value, subject)
      _ -> :ok
    end
  end

  # Fetch policy by uuid, but follow the chain of replacements if any
  defp fetch_policy(uuid, subject) do
    case Policies.fetch_policy_by_id(uuid, subject) do
      {:ok, policy} when policy.replaced_by_policy_id != nil -> fetch_policy(policy.replaced_by_policy_id, subject)
      v -> v
    end
  end

  defp cleanup_policy(uuid, subject) do
    case fetch_policy(uuid, subject) do
      {:ok, value} when value.deleted_at == nil ->
        Logger.info("Deleting removed policy #{value.description}")
        {:ok, _} = Policies.delete_policy(value, subject)
      _ -> :ok
    end
  end

  defp cleanup_entity_type(account_slug, entity_type, cleanup_fn, temp_admin_subject) do
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
          cleanup_fn.(uuid, temp_admin_subject)
          UuidMapping.remove_entity(account_slug, entity_type, entity_id)
      end
    end)
  end

  defp collect_current_entities(account_data) do
    %{
      "actors" => Map.keys(account_data["actors"] || %{}),
      "providers" => Map.keys(account_data["auth"] || %{}),
      "gateway_groups" => Map.keys(account_data["gatewayGroups"] || %{}),
      "relay_groups" => Map.keys(account_data["relayGroups"] || %{}),
      "actor_groups" => Map.keys(account_data["groups"] || %{}) ++ ["everyone"],
      "resources" => Map.keys(account_data["resources"] || %{}),
      "policies" => Map.keys(account_data["policies"] || %{})
    }
  end

  defp nil_if_deleted_or_not_found(value) do
    case value do
      nil -> nil
      {:error, :not_found} -> nil
      {:ok, value} when value.deleted_at != nil -> nil
      v -> v
    end
  end

  defp create_temp_admin(account, email_provider) do
    temp_admin_actor_email = "firezone-provision@localhost.local"
    temp_admin_actor_context = %Auth.Context{
      type: :browser,
      user_agent: "Unspecified/0.0",
      remote_ip: {127, 0, 0, 1},
      remote_ip_location_region: "N/A",
      remote_ip_location_city: "N/A",
      remote_ip_location_lat: 0.0,
      remote_ip_location_lon: 0.0
    }

    {:ok, temp_admin_actor} =
      Actors.create_actor(account, %{
        type: :account_admin_user,
        name: "Provisioning"
      })

    {:ok, temp_admin_actor_email_identity} =
      Auth.create_identity(temp_admin_actor, email_provider, %{
        provider_identifier: temp_admin_actor_email,
        provider_identifier_confirmation: temp_admin_actor_email
      })

    {:ok, temp_admin_actor_token} =
      Auth.create_token(temp_admin_actor_email_identity, temp_admin_actor_context, "temporarynonce", DateTime.utc_now() |> DateTime.add(1, :hour))

    {:ok, temp_admin_subject} =
      Auth.build_subject(temp_admin_actor_token, temp_admin_actor_context)

    {temp_admin_subject, temp_admin_actor, temp_admin_actor_email_identity, temp_admin_actor_token}
  end

  defp cleanup_temp_admin(temp_admin_actor, temp_admin_actor_email_identity, temp_admin_actor_token, subject) do
    Logger.info("Cleaning up temporary admin actor")
    {:ok, _} = Tokens.delete_token(temp_admin_actor_token, subject)
    {:ok, _} = Auth.delete_identity(temp_admin_actor_email_identity, subject)
    {:ok, _} = Actors.delete_actor(temp_admin_actor, subject)
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
          case Accounts.fetch_account_by_id_or_slug(slug) do
            {:ok, acc} ->
              Logger.info("Updating existing account #{slug}")
              updated_acc = acc |> Ecto.Changeset.change(account_attrs) |> repo.update!()
              {:ok, {:existing, updated_acc}}
            _ ->
              Logger.info("Creating new account #{slug}")
              {:ok, account} = Accounts.create_account(account_attrs)

              Logger.info("Creating internet gateway group")
              {:ok, internet_site} = Gateways.create_internet_group(account)

              Logger.info("Creating internet resource")
              {:ok, _internet_resource} = Resources.create_internet_resource(account, internet_site)

              # Store mapping of slug to UUID
              UuidMapping.update_account(slug, account.id)
              {:ok, {:new, account}}
          end
        end)
        |> Ecto.Multi.run({:everyone_group, slug}, fn _repo, changes ->
          case Map.get(changes, {:account, slug}) do
            {:new, account} ->
              Logger.info("Creating everyone group for new account")
              {:ok, actor_group} = Actors.create_managed_group(account, %{name: "Everyone", membership_rules: [%{operator: true}]})
              UuidMapping.update_entities(slug, "actor_groups", %{"everyone" => actor_group.id})
              {:ok, actor_group}
            {:existing, _account} ->
              {:ok, :skipped}
          end
        end)
        |> Ecto.Multi.run({:email_provider, slug}, fn _repo, changes ->
          case Map.get(changes, {:account, slug}) do
            {:new, account} ->
              Logger.info("Creating default email provider for new account")
              Auth.create_provider(account, %{name: "Email", adapter: :email, adapter_config: %{}})
            {:existing, account} ->
              Auth.Provider.Query.not_disabled()
              |> Auth.Provider.Query.by_adapter(:email)
              |> Auth.Provider.Query.by_account_id(account.id)
              |> Repo.fetch(Auth.Provider.Query, [])
          end
        end)
        |> Ecto.Multi.run({:temp_admin, slug}, fn _repo, changes ->
          {_, account} = changes[{:account, slug}]
          email_provider = changes[{:email_provider, slug}]
          {:ok, create_temp_admin(account, email_provider)}
        end)

      # Clean up removed entities for this account after we have an admin subject
      multi = multi
        |> Ecto.Multi.run({:cleanup_entities, slug}, fn _repo, changes ->
          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]

          # Store current entities in process dictionary for our helper function
          current_entities = collect_current_entities(account_data)
          Process.put(:current_entities, current_entities)

          # Define entity types and their cleanup functions
          entity_types = [
            {"actors", &cleanup_actor/2},
            {"providers", &cleanup_provider/2},
            {"gateway_groups", &cleanup_gateway_group/2},
            {"relay_groups", &cleanup_relay_group/2},
            {"actor_groups", &cleanup_actor_group/2},
            {"resources", &cleanup_resource/2},
            {"policies", &cleanup_policy/2}
          ]

          # Clean up each entity type
          Enum.each(entity_types, fn {entity_type, cleanup_fn} ->
            cleanup_entity_type(slug, entity_type, cleanup_fn, temp_admin_subject)
          end)

          {:ok, :cleaned}
        end)

      # Create or update actors
      multi = Enum.reduce(account_data["actors"] || %{}, multi, fn {external_id, actor_data}, multi ->
        actor_attrs = atomize_keys(%{
          name: actor_data["name"],
          type: String.to_atom(actor_data["type"])
        })

        Ecto.Multi.run(multi, {:actor, slug, external_id}, fn _repo, changes ->
          {_, account} = changes[{:account, slug}]
          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "actors", external_id)
          case uuid && Actors.fetch_actor_by_id(uuid, temp_admin_subject) |> nil_if_deleted_or_not_found() do
            nil ->
              Logger.info("Creating new actor #{actor_data["name"]}")
              {:ok, actor} = Actors.create_actor(account, actor_attrs)
              # Update the mapping without manually handling Process.get/put.
              UuidMapping.update_entities(slug, "actors", %{external_id => actor.id})
              {:ok, {:new, actor}}
            {:ok, existing_actor} ->
              Logger.info("Updating existing actor #{actor_data["name"]}")
              {:ok, updated_act} = Actors.update_actor(existing_actor, actor_attrs, temp_admin_subject)
              {:ok, {:existing, updated_act}}
          end
        end)
        |> Ecto.Multi.run({:actor_identity, slug, external_id}, fn repo, changes ->
          email_provider = changes[{:email_provider, slug}]
          case Map.get(changes, {:actor, slug, external_id}) do
            {:new, actor} ->
              Logger.info("Creating actor email identity")
              Auth.create_identity(actor, email_provider, %{
                provider_identifier: actor_data["email"],
                provider_identifier_confirmation: actor_data["email"]
              })
            {:existing, actor} ->
              Logger.info("Updating actor email identity")
              {:ok, identity} = Auth.Identity.Query.not_deleted()
              |> Auth.Identity.Query.by_actor_id(actor.id)
              |> Auth.Identity.Query.by_provider_id(email_provider.id)
              |> Repo.fetch(Auth.Identity.Query, [])

              {:ok, identity |> Ecto.Changeset.change(%{
                provider_identifier: actor_data["email"]
              }) |> repo.update!()}
          end
        end)
      end)

      # Create or update providers
      multi = Enum.reduce(account_data["auth"] || %{}, multi, fn {external_id, provider_data}, multi ->
        Ecto.Multi.run(multi, {:provider, slug, external_id}, fn repo, changes ->
          provider_attrs = %{
            name: provider_data["name"],
            adapter: String.to_atom(provider_data["adapter"]),
            adapter_config: provider_data["adapter_config"]
          }

          {_, account} = changes[{:account, slug}]
          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "providers", external_id)
          case uuid && Auth.fetch_provider_by_id(uuid, temp_admin_subject) |> nil_if_deleted_or_not_found() do
            nil ->
              Logger.info("Creating new provider #{provider_data["name"]}")
              {:ok, provider} = Auth.create_provider(account, provider_attrs)
              UuidMapping.update_entities(slug, "providers", %{external_id => provider.id})
              {:ok, provider}
            {:ok, existing} ->
              Logger.info("Updating existing provider #{provider_data["name"]}")
              {:ok, existing |> Ecto.Changeset.change(provider_attrs) |> repo.update!()}
          end
        end)
      end)

      # Create or update gateway_groups
      multi = Enum.reduce(account_data["gatewayGroups"] || %{}, multi, fn {external_id, gateway_group_data}, multi ->
        Ecto.Multi.run(multi, {:gateway_group, slug, external_id}, fn _repo, changes ->
          gateway_group_attrs = %{
            name: gateway_group_data["name"],
            tokens: [%{}]
          }

          {_, account} = changes[{:account, slug}]
          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "gateway_groups", external_id)
          case uuid && Gateways.fetch_group_by_id(uuid, temp_admin_subject) |> nil_if_deleted_or_not_found() do
            nil ->
              Logger.info("Creating new gateway group #{gateway_group_data["name"]}")
              gateway_group = account
                |> Gateways.Group.Changeset.create(gateway_group_attrs, temp_admin_subject)
                |> Repo.insert!()
              UuidMapping.update_entities(slug, "gateway_groups", %{external_id => gateway_group.id})
              {:ok, gateway_group}
            {:ok, existing} ->
              # Nothing to update
              {:ok, existing}
          end
        end)
      end)

      # Create or update relay_groups
      multi = Enum.reduce(account_data["relayGroups"] || %{}, multi, fn {external_id, relay_group_data}, multi ->
        Ecto.Multi.run(multi, {:relay_group, slug, external_id}, fn _repo, changes ->
          relay_group_attrs = %{
            name: relay_group_data["name"]
          }

          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "relay_groups", external_id)
          existing_relay_group = uuid && Relays.fetch_group_by_id(uuid, temp_admin_subject)
          case existing_relay_group do
            v when v in [nil, {:error, :not_found}] ->
              Logger.info("Creating new relay group #{relay_group_data["name"]}")
              {:ok, relay_group} = Relays.create_group(relay_group_attrs, temp_admin_subject)
              UuidMapping.update_entities(slug, "relay_groups", %{external_id => relay_group.id})
              {:ok, relay_group}
            {:ok, existing} ->
              # Nothing to update
              {:ok, existing}
          end
        end)
      end)

      # Create or update actor_groups
      multi = Enum.reduce(account_data["groups"] || %{}, multi, fn {external_id, actor_group_data}, multi ->
        Ecto.Multi.run(multi, {:actor_group, slug, external_id}, fn _repo, changes ->
          actor_group_attrs = %{
            name: actor_group_data["name"],
            type: :static
          }

          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "actor_groups", external_id)
          case uuid && Actors.fetch_group_by_id(uuid, temp_admin_subject) |> nil_if_deleted_or_not_found() do
            nil ->
              Logger.info("Creating new actor group #{actor_group_data["name"]}")
              {:ok, actor_group} = Actors.create_group(actor_group_attrs, temp_admin_subject)
              UuidMapping.update_entities(slug, "actor_groups", %{external_id => actor_group.id})
              {:ok, actor_group}
            {:ok, existing} ->
              # Nothing to update
              {:ok, existing}
          end
        end)
        |> Ecto.Multi.run({:actor_group_members, slug, external_id}, fn repo, changes ->
          {_, account} = changes[{:account, slug}]
          group_uuid = UuidMapping.get_entity(slug, "actor_groups", external_id)

          memberships =
            Actors.Membership.Query.all()
            |> Actors.Membership.Query.by_group_id(group_uuid)
            |> Actors.Membership.Query.returning_all()
            |> Repo.all()

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

          Logger.info("Updating members for actor group #{external_id}")
          Enum.each(missing_members || [], fn actor_uuid ->
            Logger.info("Adding member #{external_id}")
            Actors.Membership.Changeset.upsert(account.id, %Actors.Membership{}, %{
              group_id: group_uuid,
              actor_id: actor_uuid
            })
            |> repo.insert!()
          end)

          if actor_group_data["forceMembers"] == true do
            # Remove untracked members
            to_delete = Enum.map(untracked_members, fn actor_uuid -> {group_uuid, actor_uuid} end)
            if to_delete != [] do
              Actors.Membership.Query.by_group_id_and_actor_id({:in, to_delete})
                |> repo.delete_all()
            end
          end

          {:ok, nil}
        end)
      end)

      # Create or update resources
      multi = Enum.reduce(account_data["resources"] || %{}, multi, fn {external_id, resource_data}, multi ->
        Ecto.Multi.run(multi, {:resource, slug, external_id}, fn _repo, changes ->
          resource_attrs = %{
            type: String.to_atom(resource_data["type"]),
            name: resource_data["name"],
            address: resource_data["address"],
            address_description: resource_data["address_description"],
            connections: Enum.map(resource_data["gatewayGroups"] || [], fn group ->
              %{gateway_group_id: UuidMapping.get_entity(slug, "gateway_groups", group)}
            end),
            filters: Enum.map(resource_data["filters"] || [], fn filter ->
              %{
                ports: filter["ports"] || [],
                protocol: String.to_atom(filter["protocol"])
              }
            end)
          }

          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "resources", external_id)
          case uuid && fetch_resource(uuid, temp_admin_subject) |> nil_if_deleted_or_not_found() do
            nil ->
              Logger.info("Creating new resource #{resource_data["name"]}")
              {:ok, resource} = Resources.create_resource(resource_attrs, temp_admin_subject)
              UuidMapping.update_entities(slug, "resources", %{external_id => resource.id})
              {:ok, resource}
            {:ok, existing} ->
              existing = Repo.preload(existing, :connections)
              Logger.info("Updating existing resource #{resource_data["name"]}")
              only_updated_attrs = resource_attrs
                |> Enum.reject(fn {key, value} ->
                  case key do
                    # Compare connections by gateway_group_id only
                    :connections -> value == Enum.map(existing.connections || [], fn conn -> Map.take(conn, [:gateway_group_id]) end)
                    # Compare filters by ports and protocol only
                    :filters -> value == Enum.map(existing.filters || [], fn filter -> Map.take(filter, [:ports, :protocol]) end)
                    _ -> Map.get(existing, key) == value
                  end
                end)
                |> Enum.into(%{})

              if only_updated_attrs == %{} do
                {:ok, existing}
              else
                resource = case existing |> Resources.update_resource(resource_attrs, temp_admin_subject) do
                  {:replaced, _old, new} ->
                    UuidMapping.update_entities(slug, "resources", %{external_id => new.id})
                    new
                  {:updated, value} -> value
                  x -> x
                end

                {:ok, resource}
              end
          end
        end)
      end)

      # Create or update policies
      multi = Enum.reduce(account_data["policies"] || %{}, multi, fn {external_id, policy_data}, multi ->
        Ecto.Multi.run(multi, {:policy, slug, external_id}, fn _repo, changes ->
          policy_attrs = %{
            description: policy_data["description"],
            actor_group_id: UuidMapping.get_entity(slug, "actor_groups", policy_data["group"]),
            resource_id: UuidMapping.get_entity(slug, "resources", policy_data["resource"])
          }

          {temp_admin_subject, _, _, _} = changes[{:temp_admin, slug}]
          uuid = UuidMapping.get_entity(slug, "policies", external_id)
          case uuid && fetch_policy(uuid, temp_admin_subject) |> nil_if_deleted_or_not_found() do
            nil ->
              Logger.info("Creating new policy #{policy_data["name"]}")
              {:ok, policy} = Policies.create_policy(policy_attrs, temp_admin_subject)
              UuidMapping.update_entities(slug, "policies", %{external_id => policy.id})
              {:ok, policy}
            {:ok, existing} ->
              Logger.info("Updating existing policy #{policy_data["name"]}")
              only_updated_attrs = policy_attrs
                |> Enum.reject(fn {key, value} -> Map.get(existing, key) == value end)
                |> Enum.into(%{})

              if only_updated_attrs == %{} do
                {:ok, existing}
              else
                policy = case existing |> Policies.update_policy(policy_attrs, temp_admin_subject) do
                  {:replaced, _old, new} ->
                    UuidMapping.update_entities(slug, "policies", %{external_id => new.id})
                    new
                  {:updated, value} -> value
                  x -> x
                end

                {:ok, policy}
              end
          end
        end)
      end)

      # Clean up temporary admin after all operations
      multi |> Ecto.Multi.run({:cleanup_temp_admin, slug}, fn _repo, changes ->
        {temp_admin_subject, temp_admin_actor, temp_admin_actor_email_identity, temp_admin_actor_token} =
          changes[{:temp_admin, slug}]

        cleanup_temp_admin(temp_admin_actor, temp_admin_actor_email_identity, temp_admin_actor_token, temp_admin_subject)
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

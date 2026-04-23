alias Domain.{Repo, Accounts, Auth, Actors, Tokens}

mappings = case File.read("provision-uuids.json") do
{:ok, content} ->
  case Jason.decode(content) do
    {:ok, mapping} -> mapping
    _ -> %{"accounts" => %{}}
  end
_ -> %{"accounts" => %{}}
end

IO.puts("INFO: Fetching account")
{:ok, account} = Accounts.fetch_account_by_id_or_slug("main")

IO.puts("INFO: Fetching email provider")
{:ok, email_provider} = Auth.Provider.Query.not_disabled()
  |> Auth.Provider.Query.by_adapter(:email)
  |> Auth.Provider.Query.by_account_id(account.id)
  |> Repo.fetch(Auth.Provider.Query, [])

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
    name: "Token Provisioning"
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

{:ok, relay_group_token} =
  Tokens.create_token(%{
    "type" => :relay_group,
	"expires_at" => DateTime.utc_now() |> DateTime.add(1, :hour),
    "secret_fragment" => Domain.Crypto.random_token(32, encoder: :hex32),
    "relay_group_id" => get_in(mappings, ["accounts", "main", "relay_groups", "my-relays"])
  })

relay_group_encoded_token = Tokens.encode_fragment!(relay_group_token)
IO.puts("Created relay token: #{relay_group_encoded_token}")
File.write("relay_token.txt", relay_group_encoded_token)

{:ok, gateway_group_token} =
  Tokens.create_token(%{
    "type" => :gateway_group,
    "expires_at" => DateTime.utc_now() |> DateTime.add(1, :hour),
    "secret_fragment" => Domain.Crypto.random_token(32, encoder: :hex32),
    "account_id" => get_in(mappings, ["accounts", "main", "id"]),
    "gateway_group_id" => get_in(mappings, ["accounts", "main", "gateway_groups", "site"])
  }, temp_admin_subject)

gateway_group_encoded_token = Tokens.encode_fragment!(gateway_group_token)
IO.puts("Created gateway group token: #{gateway_group_encoded_token}")
File.write("gateway_token.txt", gateway_group_encoded_token)

{:ok, service_account_actor_token} =
  Tokens.create_token(%{
    "type" => :client,
    "expires_at" => DateTime.utc_now() |> DateTime.add(1, :hour),
    "secret_fragment" => Domain.Crypto.random_token(32, encoder: :hex32),
    "account_id" => get_in(mappings, ["accounts", "main", "id"]),
    "actor_id" => get_in(mappings, ["accounts", "main", "actors", "client"])
  })

service_account_actor_encoded_token = Tokens.encode_fragment!(service_account_actor_token)
IO.puts("Created service actor token: #{service_account_actor_encoded_token}")
File.write("client_token.txt", service_account_actor_encoded_token)

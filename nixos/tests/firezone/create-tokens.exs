alias Portal.{Repo, Account, Auth, Actor, ClientToken, GatewayToken, RelayToken, Crypto}
import Ecto.Query

mappings = case File.read("provision-uuids.json") do
  {:ok, content} ->
    case Jason.decode(content) do
      {:ok, mapping} -> mapping
      _ -> %{"accounts" => %{}}
    end
  _ -> %{"accounts" => %{}}
end

IO.puts("INFO: Fetching account")
account = case Repo.get_by(Account, slug: "main") do
  nil -> raise "Account 'main' not found"
  account -> account
end

IO.puts("INFO: Fetching service account actor")
actor_id = get_in(mappings, ["accounts", "main", "actors", "client"])
actor = case Repo.get_by(Actor, account_id: account.id, id: actor_id) do
  nil -> raise "Actor '#{actor_id}' not found"
  actor -> actor
end

# Create relay token (global, no account association)
IO.puts("INFO: Creating relay token")
relay_secret_fragment = Crypto.random_token(32, encoder: :hex32)
relay_secret_salt = Crypto.random_token(16)
relay_secret_hash = Crypto.hash(:sha3_256, "" <> relay_secret_fragment <> relay_secret_salt)

{:ok, relay_token} = Repo.insert(%RelayToken{
  secret_fragment: relay_secret_fragment,
  secret_salt: relay_secret_salt,
  secret_hash: relay_secret_hash
})

relay_encoded_token = Auth.encode_fragment!(relay_token)
IO.puts("Created relay token: #{relay_encoded_token}")
File.write("relay_token.txt", relay_encoded_token)

# Create gateway token
IO.puts("INFO: Creating gateway token")
site_id = get_in(mappings, ["accounts", "main", "sites", "site"])
gateway_secret_fragment = Crypto.random_token(32, encoder: :hex32)
gateway_secret_salt = Crypto.random_token(16)
gateway_secret_hash = Crypto.hash(:sha3_256, "" <> gateway_secret_fragment <> gateway_secret_salt)

{:ok, gateway_token} = Repo.insert(%GatewayToken{
  account_id: account.id,
  site_id: site_id,
  secret_fragment: gateway_secret_fragment,
  secret_salt: gateway_secret_salt,
  secret_hash: gateway_secret_hash
})

gateway_encoded_token = Auth.encode_fragment!(gateway_token)
IO.puts("Created gateway token: #{gateway_encoded_token}")
File.write("gateway_token.txt", gateway_encoded_token)

# Create client token
IO.puts("INFO: Creating client token for service account")
# Get the userpass auth provider
auth_provider = Repo.one!(
  from p in Portal.Userpass.AuthProvider,
  join: base in Portal.AuthProvider, on: base.id == p.id,
  where: base.account_id == ^account.id,
  select: p
)

client_secret_fragment = Crypto.random_token(32, encoder: :hex32)
client_secret_salt = Crypto.random_token(16)
client_secret_hash = Crypto.hash(:sha3_256, "" <> client_secret_fragment <> client_secret_salt)

{:ok, client_token} = Repo.insert(%ClientToken{
  account_id: account.id,
  actor_id: actor.id,
  auth_provider_id: auth_provider.id,
  secret_fragment: client_secret_fragment,
  secret_salt: client_secret_salt,
  secret_hash: client_secret_hash,
  expires_at: DateTime.utc_now() |> DateTime.add(1, :hour)
})

client_encoded_token = Auth.encode_fragment!(client_token)
IO.puts("Created client token: #{client_encoded_token}")
File.write("client_token.txt", client_encoded_token)

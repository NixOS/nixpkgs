{ handleTest }:

{
  unencrypted = handleTest ./unencrypted.nix { };
  tls = handleTest ./tls.nix { };
}

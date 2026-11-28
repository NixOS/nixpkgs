{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_port_extension";
  version = "0.116.0";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_port_extension";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MIFfkhzvKkMiX1OecJozGkk9oBWchMyE8bmuUhEnIMk=";
  };

  cargoHash = "sha256-BTmH0SZNXDhgAnfnIDLW5DjE9mq9OjU7eCaTUSQH2dI=";

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Nushell plugin for listing active connections and scanning ports on a target address";
    mainProgram = "nu_plugin_port_extension";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})

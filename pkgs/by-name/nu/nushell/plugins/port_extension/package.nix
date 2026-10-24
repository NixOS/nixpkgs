{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_port_extension";
  version = "0.115.0";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_port_extension";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J+IWBiRQBwJSraSYY3wtSH+iCLebw57Z92T+iUlkHfQ=";
  };

  cargoHash = "sha256-r3EoXsPnn6JmyYjfh1Cs6HtuQSb2ZLg3UnWHFQLobBM=";

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Nushell plugin for listing active connections and scanning ports on a target address";
    mainProgram = "nu_plugin_port_extension";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})

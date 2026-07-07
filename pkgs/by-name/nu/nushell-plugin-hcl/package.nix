{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_hcl";
  version = "0.114.0";

  src = fetchFromGitHub {
    owner = "Yethal";
    repo = "nu_plugin_hcl";
    tag = finalAttrs.version;
    hash = "sha256-3qUsEJIF91679W2mdU9eESTNmcp3TqmMxWoR7G5uUl8=";
  };

  cargoHash = "sha256-xAURId/OvgIGvbh5be4yS2dKmQObIpb4YYlRcjcHMeU=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for parsing Hashicorp Configuration Language files";
    mainProgram = "nu_plugin_hcl";
    homepage = "https://github.com/Yethal/nu_plugin_hcl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yethal ];
  };
})

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
  version = "0.111.0";

  src = fetchFromGitHub {
    owner = "Yethal";
    repo = "nu_plugin_hcl";
    tag = finalAttrs.version;
    hash = "sha256-OeMDlzioXt4Hn3VUP7YaMHF0c8BhRDrHdrQRC595Ypc=";
  };

  cargoHash = "sha256-8ycqhuVQGyT4DabOLJIsSXY324h91zH/nUw/2XrAxwc=";

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

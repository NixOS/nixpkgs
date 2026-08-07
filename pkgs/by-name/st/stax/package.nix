{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  perl,
  pkg-config,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stax";
  version = "0.74.0";

  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "stax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Z8yfjslG0lTT0/kFO0ornssxa2VE0KhO6w//LpAdaQ=";
  };

  postPatch = ''
    # Remove darwin linker override that breaks nix builds
    rm -f .cargo/config.toml
  '';

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  cargoHash = "sha256-oUYODmjnlOKhg8OUGJmkzUX11nebutLWABOtjpr+NcE=";

  doInstallCheck = true;
  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Stacked-branch workflow for Git with an interactive TUI, smart PRs, and safe undo";
    homepage = "https://github.com/cesarferreira/stax";
    license = lib.licenses.mit;
    mainProgram = "stax";
    maintainers = with lib.maintainers; [
      henrikvtcodes
    ];
  };
})

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  perl,
  pkg-config,
  libgit2,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stax";
  version = "0.118.0";

  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "stax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UfLosYrUsTM7RchRzEYo+uE7B+EeA/uxwHtXYqzpTfk=";
  };

  env.LIBGIT2_NO_VENDOR = 1;

  postPatch = ''
    # Remove darwin linker override that breaks nix builds
    rm -f .cargo/config.toml
  '';

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  cargoHash = "sha256-fninpDZQkD8vw5lQim9UT7J+HK3ucMdpcmcy0F/Qcog=";

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

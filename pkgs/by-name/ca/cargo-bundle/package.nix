{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  libxkbcommon,
  wayland,
  openssl,
  squashfsTools,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bundle";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Ulah5NtjQh5dIB/nhTrDstnaub4LS9iH33E1iv1JpY=";
  };

  cargoHash = "sha256-qE0ZDq0UJHfsivvI1W44u/pVjKMDGrghSl7sfau/pIY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    wayland
    openssl
  ];

  postFixup = ''
    wrapProgram $out/bin/cargo-bundle \
      --prefix PATH : ${lib.makeBinPath [ squashfsTools ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrap rust executables in OS-specific app bundles";
    mainProgram = "cargo-bundle";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})

{
  rustPlatform,
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  nix-prefetch-git,
  gitMinimal,
  nix,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = finalAttrs.version;
    hash = "sha256-rNQ3RuTYu7gM/pmchuvb/xNeRo/m82M4iZq2g89r3UA=";
  };

  sourceRoot = "source/rust/lon";

  cargoHash = "sha256-mbGMStrC2GRMpL0+yr5WpLLZRT+vNDwjufymoRZwuIk=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  postInstall = ''
    wrapProgram $out/bin/lon --prefix PATH : ${
      lib.makeBinPath [
        nix-prefetch-git
        gitMinimal
      ]
    }
  '';

  nativeCheckInputs = [
    gitMinimal
    nix-prefetch-git
    nix
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lock & update Nix dependencies";
    homepage = "https://github.com/nikstur/lon";
    changelog = "https://github.com/nikstur/lon/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      ma27
      nikstur
    ];
    license = lib.licenses.mit;
    mainProgram = "lon";
  };
})

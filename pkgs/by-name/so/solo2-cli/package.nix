{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  pcsclite,
  udev,
  udevCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "solo2-cli";
  version = "0.3.0-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = "solo2";
    rev = "45311f0b6761187d409ea3e7ea34f896810eb156";
    hash = "sha256-OrFynFw1zDafvs8b+JkIn5mCgN+zs6O1w6ChOxtFAvY=";
  };

  cargoHash = "sha256-eSMaIVB/6HOKdE/dCUfIYZqKZeY3qDrPKsJNS/i943M=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    udevCheckHook
  ];

  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pcsclite
      udev
    ];

  postInstall = ''
    install -D cli/70-solo2.rules $out/lib/udev/rules.d/70-solo2.rules
    installShellCompletion target/*/release/solo2.{bash,fish}
    installShellCompletion --zsh target/*/release/_solo2
  '';

  doCheck = true;
  doInstallCheck = true;

  buildFeatures = [ "cli" ];

  meta = {
    description = "CLI tool for managing SoloKeys' Solo2 USB security keys";
    homepage = "https://github.com/solokeys/solo2";
    license = with lib.licenses; [
      asl20
      mit
    ]; # either at your option
    maintainers = with lib.maintainers; [
      magicquark
      lukegb
    ];
    mainProgram = "solo2";
  };
})

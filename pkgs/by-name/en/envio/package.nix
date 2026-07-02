{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  gpgme,
  dbus,
  libgpg-error,
  pkg-config,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "envio";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "humblepenguinn";
    repo = "envio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uiuJ3yFuU5S0e6SrD1C4tU5Ve/VBoGmyclbokESDZAw=";
  };

  cargoHash = "sha256-eECjTnqjy38jA5kHddPaBZaZ/1ErHB7uQPbZYNFBcSU=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libgpg-error
    gpgme
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
  ];

  postInstall = ''
    installManPage man/*.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/humblepenguinn/envio/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Modern and secure CLI tool for managing environment variables";
    mainProgram = "envio";
    longDescription = ''
      Envio is a command-line tool that simplifies the management of
      environment variables across multiple profiles. It allows users to easily
      switch between different configurations and apply them to their current
      environment.
    '';
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ afh ];
  };
})

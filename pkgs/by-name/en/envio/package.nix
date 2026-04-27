{
  lib,
  fetchFromGitHub,
  installShellFiles,
  gpgme,
  libgpg-error,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "envio";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "humblepenguinn";
    repo = "envio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-je0DBoBIayFK//Aija5bnO/2z+hxNWgVkwOgxMyq5s4=";
  };

  cargoHash = "sha256-stb5BZ77yBUjP6p3yfdgtN6fkE7wWU6A+sPAmc8YZD0=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libgpg-error
    gpgme
  ];

  postInstall = ''
    installManPage man/*.1
  '';

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

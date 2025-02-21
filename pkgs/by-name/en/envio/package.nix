{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  darwin,
  gpgme,
  libgpg-error,
  pkg-config,
  rustPlatform,
}:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in
rustPlatform.buildRustPackage rec {
  pname = "envio";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "envio-cli";
    repo = "envio";
    rev = "v${version}";
    hash = "sha256-je0DBoBIayFK//Aija5bnO/2z+hxNWgVkwOgxMyq5s4=";
  };

  cargoHash = "sha256-L7GgPocj32zAfR27dgKK7/OM106cATdCqufSvG3MFYQ=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libgpg-error
    gpgme
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  postInstall = ''
    installManPage man/*.1
  '';

  meta = with lib; {
    homepage = "https://envio-cli.github.io/home";
    changelog = "https://github.com/envio-cli/envio/blob/${version}/CHANGELOG.md";
    description = "Modern and secure CLI tool for managing environment variables";
    mainProgram = "envio";
    longDescription = ''
      Envio is a command-line tool that simplifies the management of
      environment variables across multiple profiles. It allows users to easily
      switch between different configurations and apply them to their current
      environment.
    '';
    license = with licenses; [
      mit
      asl20
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ afh ];
  };
}

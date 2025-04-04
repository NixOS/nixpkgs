{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "9.0.4";

  src = fetchFromGitHub {
    owner = "findomain";
    repo = "findomain";
    tag = version;
    hash = "sha256-5jbKDMULig6j3D5KEQQrHWtsc59x0Tj6n/7kwK/8IME=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4+nRQ8HL4dQMCgeSOrgkaRj0E4HPAC3Nm82AEr1KWJo=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installManPage findomain.1
  '';

  meta = with lib; {
    description = "Fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Findomain/Findomain";
    changelog = "https://github.com/Findomain/Findomain/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      Br1ght0ne
      figsoda
    ];
    mainProgram = "findomain";
  };
}

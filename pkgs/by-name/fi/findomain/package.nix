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
  version = "9.0.3";

  src = fetchFromGitHub {
    owner = "findomain";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-M6i62JI4HjaM0C2rSK8P5O19JeugFP5xIy1E6vE8KP4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2CB7xmZFqej+vOx90kOPcI4FNpj1z4wnW90n7yEFpNA=";

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

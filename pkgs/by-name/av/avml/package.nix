{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  avml,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "avml";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "avml";
    tag = "v${version}";
    hash = "sha256-MIqQ5NRWAfXm7AblsKCrUiaYN5IGUo2jWJMJZL+w3V4=";
  };

  cargoHash = "sha256-gcpjrxnQDyO92OW6LZVc4x73TmTtQoaEYhmGmqhz8ng=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.tests.version = testers.testVersion { package = avml; };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A portable volatile memory acquisition tool for Linux";
    homepage = "https://github.com/microsoft/avml";
    license = licenses.mit;
    maintainers = [ maintainers.lesuisse ];
    platforms = platforms.linux;
    mainProgram = "avml";
  };
}

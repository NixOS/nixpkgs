{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-MIqQ5NRWAfXm7AblsKCrUiaYN5IGUo2jWJMJZL+w3V4=";
  };

  cargoHash = "sha256-gcpjrxnQDyO92OW6LZVc4x73TmTtQoaEYhmGmqhz8ng=";

  nativeBuildInputs = [ perl ];

  passthru.tests.version = testers.testVersion { package = avml; };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A portable volatile memory acquisition tool for Linux";
    homepage = "https://github.com/microsoft/avml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lesuisse ];
    platforms = lib.platforms.linux;
    mainProgram = "avml";
  };
}

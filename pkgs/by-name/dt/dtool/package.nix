{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dtool";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "guoxbin";
    repo = "dtool";
    rev = "v${version}";
    hash = "sha256-m4H+ANwEbK6vGW3oIVZqnqvMiAKxNJf2TLIGh/G6AU4=";
  };

  cargoHash = "sha256-C0H5cIMMfUPJ2iJCUs1jEu3Ln8CdDgbgstMnH/f9FRY=";
  # FIXME: remove patch when upstream version of rustc-serialize is updated
  cargoPatches = [ ./rustc-serialize-fix.patch ];

  checkType = "debug";

  meta = with lib; {
    description = "Command-line tool collection to assist development written in RUST";
    homepage = "https://github.com/guoxbin/dtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linuxissuper ];
    mainProgram = "dtool";
  };
}

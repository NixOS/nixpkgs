{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = version;
    hash = "sha256-GgKY7HDu6e/hpYNOZdcjLvaNfQOZMl+H6CmKTbd1LNE=";
  };

  cargoHash = "sha256-oC5HA6diRlRWoeeQQgWR32yxZ2BLyFmKbaSkFBLdrXc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  meta = with lib; {
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "lighthouse";
  };
}

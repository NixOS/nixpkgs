{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = version;
    hash = "sha256-FiS+jB5l5xtFIVISA6+K/jbyJZFPwLvy7G+dA+78kZU=";
  };

  cargoHash = "sha256-5IrY1ohG5oJF+LvrcHrHYT2nslICQPZptJYrrwMEmwQ=";

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

{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  autoPatchelfHook,
  gcc-unwrapped,
  wayland,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlgreet";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    hash = "sha256-qfEzr8tAE1+PK7xs1NQ1q6d/GlFA7/kSWXbJDOCrEsw=";
  };

  cargoHash = "sha256-1ugExUtrzqyd9dTlBHcc44UrtEfYrfUryuG79IkTv2Y=";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ gcc-unwrapped ];

  runtimeDependencies = map lib.getLib [
    gcc-unwrapped
    wayland
    libxkbcommon
  ];

  meta = with lib; {
    description = "Raw wayland greeter for greetd, to be run under sway or similar";
    mainProgram = "wlgreet";
    homepage = "https://git.sr.ht/~kennylevinsen/wlgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}

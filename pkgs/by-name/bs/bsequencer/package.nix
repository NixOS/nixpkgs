{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
  cairo,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "bsequencer";
  version = "1.8.10";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "BSEQuencer";
    tag = version;
    sha256 = "sha256-1PSICm5mw37nO3gkHA9MNUH+CFULeOZURjimYEA/dXA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    cairo
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/sjaehn/BSEQuencer";
    description = "Multi channel MIDI step sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}

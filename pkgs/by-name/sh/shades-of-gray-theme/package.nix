{ lib, stdenv, fetchFromGitHub, gtk_engines, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "shades-of-gray-theme";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "WernerFP";
    repo = pname;
    rev = version;
    sha256 = "13ydym0i3032g5dyrnl5wxpvxv57b43q7iaq5achpmaixgn58gs8";
  };

  buildInputs = [ gtk_engines ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Shades-of-gray* $out/share/themes/
  '';

  meta = with lib; {
    description = "Flat dark GTK theme with ergonomic contrasts";
    homepage = "https://github.com/WernerFP/Shades-of-gray-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

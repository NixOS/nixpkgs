{ stdenv, fetchFromGitHub, freetype, libXrender, libXft, xextproto
, xinput, libXi, libXext, libXtst, libXpm, libX11, xproto, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "xkbd-${version}";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "mahatma-kaganovich";
    repo = "xkbd";
    rev = name;
    sha256 = "05ry6q75jq545kf6p20nhfywaqf2wdkfiyp6iwdpv9jh238hf7m9";
  };

  buildInputs = [
    freetype libXrender libXft libXext libXtst libXpm libX11
    libXi xextproto xinput xproto
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mahatma-kaganovich/xkbd;
    description = "onscreen soft keyboard for X11";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}

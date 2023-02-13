{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, gtk3, vte, lua5_3, pcre2 }:

stdenv.mkDerivation rec {
  pname = "tym";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "endaaman";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "sha256-BYWfrvodmrOw2so64Y+bzTWwXosR1NjgrimULTuQu94=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    gtk3
    vte
    lua5_3
    pcre2
  ];

  meta = with lib; {
    description = "Lua-configurable terminal emulator";
    homepage = "https://github.com/endaaman/tym";
    license = licenses.mit;
    maintainers = [ maintainers.wesleyjrz ];
    platforms = platforms.linux;
  };
}

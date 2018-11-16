{ stdenv, fetchFromGitHub, pkgconfig, writeText
, ncurses, wayland, wayland-protocols, wld, libxkbcommon, fontconfig, pixman
, conf, patches }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-velox-${version}";
  version = "git-2016-12-22";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "st";
    rev = "b27f17da65f74b0a923952601873524e03b4d047";
    sha256 = "17aa4bz5g14jvqghk2c8mw77hb8786s07pv814rmlk7nnsavmp3i";
  };

  inherit patches;

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses wayland wayland-protocols wld libxkbcommon fontconfig pixman ];

  NIX_LDFLAGS = "-lfontconfig";

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = https://st.suckless.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}

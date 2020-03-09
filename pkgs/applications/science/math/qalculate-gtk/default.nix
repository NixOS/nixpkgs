{ stdenv, fetchFromGitHub, intltool, autoreconfHook, pkgconfig, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "qalculate-gtk";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    rev = "v${version}";
    sha256 = "1zzvxkpman75lxhhvyggwzvrlc6v0rd5ak76rmcny51i4xirmrc0";
  };

  patchPhase = ''
    substituteInPlace src/main.cc --replace 'getPackageDataDir().c_str()' \"$out/share\"
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The ultimate desktop calculator";
    homepage = http://qalculate.github.io;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}

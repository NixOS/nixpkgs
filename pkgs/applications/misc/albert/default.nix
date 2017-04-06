{ stdenv, fetchFromGitHub, qtbase, qtsvg, qtx11extras, makeQtWrapper, muparser, cmake }:

stdenv.mkDerivation rec {
  name    = "albert-${version}";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner  = "albertlauncher";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "0plb8c7js91bpf7qgq1snhry8x4zixyy34lq42nhsglab2kaq4ns";
  };

  nativeBuildInputs = [ cmake makeQtWrapper ];

  buildInputs = [ qtbase qtsvg qtx11extras muparser ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i "/QStringList dirs = {/a    \"$out/lib\"," \
      src/lib/albert/src/pluginsystem/extensionmanager.cpp
  '';

  fixupPhase = ''
    wrapQtProgram $out/bin/albert
  '';

  meta = with stdenv.lib; {
    homepage    = https://albertlauncher.github.io/;
    description = "Desktop agnostic launcher";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}

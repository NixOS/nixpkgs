{ mkDerivation, lib, fetchFromGitHub, makeWrapper, qtbase, qtsvg, qtx11extras, muparser, cmake }:

mkDerivation rec {
  name    = "albert-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner  = "albertlauncher";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "120l7hli2l4qj2s126nawc4dsy4qvwvb0svc42hijry4l8imdhkq";
  };

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = [ qtbase qtsvg qtx11extras muparser ];

  enableParallelBuilding = true;

  postPatch = ''
    sed -i "/QStringList dirs = {/a    \"$out/lib\"," \
      src/lib/albert/src/albert/extensionmanager.cpp
  '';

  preBuild = ''
    mkdir -p "$out/"
    ln -s "$PWD/lib" "$out/lib"
  '';

  postBuild = ''
    rm "$out/lib"
  '';

  postInstall = ''
    wrapProgram $out/bin/albert \
      --prefix XDG_DATA_DIRS : $out/share
  '';

  meta = with lib; {
    homepage    = https://albertlauncher.github.io/;
    description = "Desktop agnostic launcher";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}

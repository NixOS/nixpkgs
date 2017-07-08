{ mkDerivation, lib, fetchFromGitHub, qtbase, qtsvg, qtx11extras, muparser, cmake }:

mkDerivation rec {
  name    = "albert-${version}";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner  = "albertlauncher";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "0ddz6h1334b9kqy1lfi7qa21znm3l0b9h0d4s62llxdasv103jh5";
  };

  nativeBuildInputs = [ cmake ];

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

  meta = with lib; {
    homepage    = https://albertlauncher.github.io/;
    description = "Desktop agnostic launcher";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes ];
    platforms   = platforms.linux;
  };
}

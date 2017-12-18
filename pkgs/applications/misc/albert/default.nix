{ mkDerivation, lib, fetchFromGitHub, makeWrapper, qtbase,
  qtdeclarative, qtsvg, qtx11extras, muparser, cmake, python3 }:

mkDerivation rec {
  name    = "albert-${version}";
  version = "0.14.14";

  src = fetchFromGitHub {
    owner  = "albertlauncher";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "1skh709f4y4p0vqabvvysn6fgws2yq8izbwkib7rfjc357chhmi7";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = [ qtbase qtdeclarative qtsvg qtx11extras muparser python3 ];

  enableParallelBuilding = true;

  # We don't have virtualbox sdk so disable plugin
  cmakeFlags = [ "-DBUILD_VIRTUALBOX=OFF" "-DCMAKE_INSTALL_LIBDIR=libs" ];

  postPatch = ''
    sed -i "/QStringList dirs = {/a    \"$out/libs\"," \
      lib/albertcore/src/core/albert.cpp
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

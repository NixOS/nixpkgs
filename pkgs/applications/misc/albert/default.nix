{ mkDerivation, lib, fetchFromGitHub, makeWrapper, qtbase,
  qtdeclarative, qtsvg, qtx11extras, muparser, cmake, python3,
  qtcharts }:

mkDerivation rec {
  pname = "albert";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner  = "albertlauncher";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "0lpp8rqx5b6rwdpcdldfdlw5327harr378wnfbc6rp3ajmlb4p7w";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = [ qtbase qtdeclarative qtsvg qtx11extras muparser python3 qtcharts ];

  # We don't have virtualbox sdk so disable plugin
  cmakeFlags = [ "-DBUILD_VIRTUALBOX=OFF" "-DCMAKE_INSTALL_LIBDIR=libs" ];

  postPatch = ''
    sed -i "/QStringList dirs = {/a    \"$out/libs\"," \
      src/app/main.cpp
  '';

  preBuild = ''
    mkdir -p "$out/"
    ln -s "$PWD/lib" "$out/lib"
  '';

  postBuild = ''
    rm "$out/lib"
  '';

  meta = with lib; {
    homepage    = "https://albertlauncher.github.io/";
    description = "Desktop agnostic launcher";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes synthetica ];
    platforms   = platforms.linux;
  };
}

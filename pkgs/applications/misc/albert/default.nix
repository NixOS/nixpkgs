{ mkDerivation, lib, fetchFromGitHub, makeWrapper, qtbase,
  qtdeclarative, qtsvg, qtx11extras, muparser, cmake, python3,
  qtcharts }:

mkDerivation rec {
  pname = "albert";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner  = "albertlauncher";
    repo   = "albert";
    rev    = "v${version}";
    sha256 = "04sr35fqz66i24lv7r2p9qfqxs55i8xpj7aam0v9yakcr33lf55a";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = [ qtbase qtdeclarative qtsvg qtx11extras muparser python3 qtcharts ];

  enableParallelBuilding = true;

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

  postInstall = ''
    wrapProgram $out/bin/albert \
      --prefix XDG_DATA_DIRS : $out/share
  '';

  meta = with lib; {
    homepage    = https://albertlauncher.github.io/;
    description = "Desktop agnostic launcher";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericsagnes synthetica ];
    platforms   = platforms.linux;
  };
}

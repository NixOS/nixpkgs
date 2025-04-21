{
  stdenv,
  lib,
  fetchzip,
  boost,
  curl,
  hwloc,
  gmp,
}:

let
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcDir =
    {
      x86_64-linux = "linux64";
      i686-linux = "linux";
      x86_64-darwin = "macosx64";
    }
    ."${stdenv.hostPlatform.system}" or throwSystem;

  gwnum =
    {
      x86_64-linux = "make64";
      i686-linux = "makefile";
      x86_64-darwin = "makemac";
    }
    ."${stdenv.hostPlatform.system}" or throwSystem;
in

stdenv.mkDerivation {
  pname = "mprime";
  version = "30.19b21";

  src = fetchzip {
    url = "https://www.mersenne.org/download/software/v30/30.19/p95v3019b21.source.zip";
    hash = "sha256-ThZ1A29ZP8RyXGBBdO12+OIBppN0pzNBkXgo/J/z6XQ=";
    stripRoot = false;
  };

  postPatch = ''
    sed -i ${srcDir}/makefile \
      -e 's/^LFLAGS =.*//'
    substituteInPlace ${srcDir}/makefile \
      --replace-fail '-Wl,-Bstatic'  "" \
      --replace-fail '-Wl,-Bdynamic' ""
  '';

  buildInputs = [
    boost
    curl
    hwloc
    gmp
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    make -C gwnum -f ${gwnum}
    make -C ${srcDir}
  '';

  installPhase = ''
    install -Dm555 -t $out/bin ${srcDir}/mprime
  '';

  meta = {
    description = "Mersenne prime search / System stability tester";
    longDescription = ''
      MPrime is the Linux command-line interface version of Prime95, to be run
      in a text terminal or in a terminal emulator window as a remote shell
      client. It is identical to Prime95 in functionality, except it lacks a
      graphical user interface.
    '';
    homepage = "https://www.mersenne.org/";
    # Unfree, because of a license requirement to share prize money if you find
    # a suitable prime. http://www.mersenne.org/legal/#EULA
    license = lib.licenses.unfree;
    # Untested on linux-32 and osx. Works in theory.
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    mainProgram = "mprime";
  };
}

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

  # The program recommends reading stress.txt, but the text files are not included in the source zip.
  # So we also download the binary tarball, to extract the text files from.
  # The next source release should contain the txt files so we can remove this hack.
  # Note: 30.19b20 is the latest binary version at the time of writing, and is not the same as the actual source below.
  binSrc = fetchzip {
    url = "https://www.mersenne.org/download/software/v30/30.19/p95v3019b20.linux64.tar.gz";
    hash = "sha256-JJQ2HYq4nH42sigVajZMJQkbzVsiP8QKnJnGK/a/QmA=";
    stripRoot = false;
  };
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
    # The program refers the user to these files, make them easier to find and open
    substituteInPlace ${srcDir}/menu.c \
      --replace-fail "stress.txt" "$out/share/mprime/doc/stress.txt" \
      --replace-fail "readme.txt" "$out/share/mprime/doc/readme.txt"
    substituteInPlace commonb.c \
      --replace-fail "stress.txt" "$out/share/mprime/doc/stress.txt" \
      --replace-fail "readme.txt" "$out/share/mprime/doc/readme.txt"
  '';

  buildInputs = [
    boost
    curl
    hwloc
    gmp
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    make -C gwnum -f ${gwnum} ''${enableParallelBuilding:+-j$NIX_BUILD_CORES}
    make -C ${srcDir} ''${enableParallelBuilding:+-j$NIX_BUILD_CORES}
  '';

  installPhase = ''
    install -Dm555 -t $out/bin ${srcDir}/mprime

    install -Dm444 -t $out/share/mprime/doc ${binSrc}/license.txt
    install -Dm444 -t $out/share/mprime/doc ${binSrc}/readme.txt
    install -Dm444 -t $out/share/mprime/doc ${binSrc}/stress.txt
    install -Dm444 -t $out/share/mprime/doc ${binSrc}/undoc.txt
    install -Dm444 -t $out/share/mprime/doc ${binSrc}/whatsnew.txt
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

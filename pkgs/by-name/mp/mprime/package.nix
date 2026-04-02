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

  docDir = "share/mprime/doc";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mprime";
  version = "31.04b02";

  src = fetchzip {
    url = "https://download.mersenne.ca/gimps/v31/31.04/p95v${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.source.zip";
    hash = "sha256-W8ic709bgm9KbVxe1fvIEC8J8LrwwMfAajX1bKhv6EM=";
    stripRoot = false;
  };

  postPatch = ''
    sed -i ${srcDir}/makefile \
      -e 's/^LFLAGS =.*//'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace ${srcDir}/makefile \
      --replace-fail '-Wl,-Bstatic'  "" \
      --replace-fail '-Wl,-Bdynamic' ""
  ''
  + ''
    # The program refers the user to these files, make them easier to find and open
    substituteInPlace ${srcDir}/menu.c \
      --replace-fail "stress.txt" "$out/${docDir}/stress.txt" \
      --replace-fail "readme.txt" "$out/${docDir}/readme.txt"
    substituteInPlace commonb.c \
      --replace-fail "stress.txt" "$out/${docDir}/stress.txt" \
      --replace-fail "readme.txt" "$out/${docDir}/readme.txt"
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

    install -Dm444 -t $out/${docDir} license.txt readme.txt stress.txt undoc.txt
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
    maintainers = with lib.maintainers; [ dstremur ];
    mainProgram = "mprime";
  };
})

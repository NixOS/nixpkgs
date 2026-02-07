{
  stdenv,
  lib,
  fetchurl,
  unzip,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "mprime";
  version = "30.19b21";
  src = fetchurl {
    url = "https://download.mersenne.ca/gimps/v30/30.19/p95v${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.source.zip";
    hash = "sha256-vchDpUem+R3GcASj77zZmFivfbB17Nd7cYiyPlrCzio=";
  };

  postPatch = ''
    sed -i ${finalAttrs.srcDir}/makefile \
      -e 's/^LFLAGS =.*//'
    substituteInPlace ${finalAttrs.srcDir}/makefile \
      --replace '-Wl,-Bstatic'  "" \
      --replace '-Wl,-Bdynamic' ""
  '';

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  buildInputs = [
    boost
    curl
    hwloc
    gmp
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    make -C gwnum -f ${gwnum}
    make -C ${finalAttrs.srcDir}
  '';

  installPhase = ''
    install -Dm555 -t $out/bin ${finalAttrs.srcDir}/mprime
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

{
  lib,
  bison,
  buildPackages,
  fetchurl,
  installShellFiles,
  pkgsBuildTarget,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jam";
  version = "2.6.1";

  src = fetchurl {
    url = "https://swarm.workshop.perforce.com/downloads/guest/perforce_software/jam/jam-${finalAttrs.version}.tar";
    hash = "sha256-rOayJ8GpmFk0/RPJwK5Pf/RBccbe2Lg7s9p15u/cs6c=";
  };

  outputs = [
    "out"
    "doc"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    bison
    installShellFiles
  ];

  makeFlags = [
    "CC=${buildPackages.stdenv.cc.targetPrefix}cc"
  ];

  env = {
    LOCATE_TARGET = "bin.unix";
    # Jam uses c89 conventions
    NIX_CFLAGS_COMPILE = "-std=c89";
  };

  enableParallelBuilding = true;

  strictDeps = true;

  # Jambase expects ar to have flags.
  preConfigure = ''
    export AR="$AR rc"
  '';

  postPatch = ''
    substituteInPlace jam.h --replace-fail 'ifdef linux' 'ifdef __linux__'
  ''
  +
    # When cross-compiling, we need to set the preprocessor macros
    # OSMAJOR/OSMINOR/OSPLAT to the values from the target platform, not the host
    # platform. This looks a little ridiculous because the vast majority of build
    # tools don't embed target-specific information into their binary, but in this
    # case we behave more like a compiler than a make(1)-alike.
    lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
       cat >>jam.h <<EOF
       #undef OSMAJOR
       #undef OSMINOR
       #undef OSPLAT
       $(
         ${pkgsBuildTarget.targetPackages.stdenv.cc}/bin/${pkgsBuildTarget.targetPackages.stdenv.cc.targetPrefix}cc -E -dM jam.h | grep -E '^#define (OSMAJOR|OSMINOR|OSPLAT) '
        )
      EOF
    '';

  buildPhase = ''
    runHook preBuild
    make $makeFlags jam0
    ./jam0 -j$NIX_BUILD_CORES -sCC=${buildPackages.stdenv.cc.targetPrefix}cc jambase.c
    ./jam0 -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    installBin bin.unix/jam
    install -Dm644 -t ''${!outputDoc}/share/doc/jam-${finalAttrs.version}/ *.html

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "jam -v";
    };
    tests.os = testers.runCommand {
      name = "${finalAttrs.finalPackage.name}-os";
      nativeBuildInputs = [ finalAttrs.finalPackage ];
      script = ''
        echo 'echo $(OS) ;' > Jamfile
        os=$(jam -d0)
        [[ $os != UNKNOWN* ]] && touch $out
      '';
    };
  };

  meta = {
    homepage = "https://swarm.workshop.perforce.com/projects/perforce_software-jam";
    description = "Just Another Make";
    longDescription = ''
      Jam is a program construction tool, like make(1).

      Jam recursively builds target files from source files, using dependency
      information and updating actions expressed in the Jambase file, which is
      written in jam's own interpreted language. The default Jambase is compiled
      into jam and provides a boilerplate for common use, relying on a
      user-provide file "Jamfile" to enumerate actual targets and sources.
    '';
    license = lib.licenses.free;
    mainProgram = "jam";
    maintainers = with lib.maintainers; [
      impl
      orivej
    ];
    platforms = lib.platforms.unix;
  };
})

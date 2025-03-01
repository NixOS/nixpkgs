{
  lib,
  stdenv,
  autoreconfHook,
  fetchDebianPatch,
  fetchurl,
  pkg-config,
  testers,
  validatePkgConfig,
  writeText,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "liblzf";
  version = "3.6";
  shlib_version = "1:0:0"; # for libtool

  # used for changelog
  cvsTag = "rel-${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";

  src = fetchurl {
    url = "http://dist.schmorp.de/liblzf/liblzf-${finalAttrs.version}.tar.gz";
    hash = "sha256-nF3gH3ucyuQMP2GdJqer7JmGwGw20mDBec7dBLiftGo=";
  };

  patches = [
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "4";
      patch = "0001-Make-sure-that-the-library-is-linked-with-C-symbols.patch";
      hash = "sha256-Rgfp/TysRcEJaogOo/Xno+G4HZzj9Loa69DL43Bp1Ok=";
    })
    # we patch configure.ac to enable libtool and add a pkg-config file
    ./0001-shared_library.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    validatePkgConfig
  ];

  postPatch =
    let
      pkgConfigIn = writeText "liblzf.pc.in" ''
        prefix=@prefix@
        exec_prefix=@exec_prefix@
        libdir=@libdir@
        includedir=@includedir@

        Name: ${finalAttrs.pname}
        Description: ${finalAttrs.meta.description}
        URL: ${finalAttrs.meta.homepage}
        Version: @VERSION@
        Libs: -L$${libdir} -llzf
        Cflags: -I$${includedir}
      '';
    in
    ''
      echo "${finalAttrs.version}" > VERSION
      echo "${finalAttrs.shlib_version}" > VERSION_INFO
      cp ${./Makefile.am} ./Makefile.am
      cp ${pkgConfigIn} ./liblzf.pc.in
    '';

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests = {
    pkgConfigTest = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };

    exeTest = testers.runCommand {
      name = "${finalAttrs.pname}-exe-test";
      buildInputs = [ finalAttrs.finalPackage ];
      script = ''
        lzf -h 2> /dev/null

        echo "LZFLZFLZFLZFLZFLZFLZFLZF" > test.txt

        # unlzf writes to filename minus ".lzf"
        cp test.txt test.txt.orig

        lzf test.txt
        unlzf test.txt.lzf

        # Compare results
        if ! cmp -s test.txt test.txt.orig; then
          echo "Executable test failed: files don't match"
          exit 1
        fi

        echo "Decompressed output matches test string (lzf & unlzf)"

        touch $out
      '';
    };

    shlibTest = testers.runCommand {
      name = "${finalAttrs.pname}-shlib-test";
      inherit stdenv; # with CC
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        finalAttrs.finalPackage.dev
        finalAttrs.finalPackage
      ];
      # tests both the library and pkg-config file
      script = ''
        $CC -g ${./lib_test.c} -o lib_test \
          $(pkg-config --cflags --libs liblzf)

        ./lib_test >/dev/null

        echo "Built and tested file linked against liblzf using pkg-config"
        touch $out
      '';
    };
  };

  meta = {
    changelog = "http://cvs.schmorp.de/liblzf/Changes?pathrev=rel-$finalAttrs.cvsTag}";
    description = "Small data compression library";
    downloadPage = "http://dist.schmorp.de/liblzf/";
    homepage = "http://software.schmorp.de/pkg/liblzf.html";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    mainProgram = "lzf";
    maintainers = with lib.maintainers; [
      tetov
    ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "liblzf" ];
  };
})

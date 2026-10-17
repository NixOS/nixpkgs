{
  lib,
  stdenv,
  fetchDebianPatch,
  fetchurl,
  testers,
  validatePkgConfig,

  cmake,
  pkg-config,
}:
let
  debianRevision = toString 4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "liblzf";
  version = "3.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://dist.schmorp.de/liblzf/liblzf-${finalAttrs.version}.tar.gz";
    hash = "sha256-nF3gH3ucyuQMP2GdJqer7JmGwGw20mDBec7dBLiftGo=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  prePatch =
    let
      debianBaseUrl = "https://sources.debian.org/data/main/libl/liblzf/${finalAttrs.version}-${debianRevision}/debian";

      debianCmakeLists = fetchurl {
        url = "${debianBaseUrl}/extras/CMakeLists.txt";
        hash = "sha256-QlgWq7xLhgvhBvtZ1e2ngMTpA/Dp6USdVgN+RfgO5x4=";
      };

      debianCmakeConfig = fetchurl {
        url = "${debianBaseUrl}/extras/liblzf-config.cmake.in";
        hash = "sha256-WvQ+QAFGxaPCz80ne3OA4L5cc/vUp5iMQe/2wGfoTMw=";
      };

      debianPkgConfig = fetchurl {
        url = "${debianBaseUrl}/extras/liblzf.pc.in";
        hash = "sha256-0KBA1duW420/DgaXQiyNlKBkQpVBH6LPucf11e4b8go=";
      };
    in
    ''
      cp --no-preserve=mode ${debianCmakeLists} CMakeLists.txt
      cp --no-preserve=mode ${debianCmakeConfig} liblzf-config.cmake.in
      cp --no-preserve=mode ${debianPkgConfig} liblzf.pc.in
    '';

  patches = [
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      inherit debianRevision;
      patch = "0001-Make-sure-that-the-library-is-linked-with-C-symbols.patch";
      hash = "sha256-Rgfp/TysRcEJaogOo/Xno+G4HZzj9Loa69DL43Bp1Ok=";
    })
    ./cmake.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  postInstall = ''
    ln -s lzf $bin/bin/unlzf
    ln -s liblzf/lzf.h $dev/include/lzf.h
  '';

  passthru.tests = {
    cmakeConfigTest = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "liblzf" ];
    };

    pkgConfigTest = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };

    exeTest = testers.runCommand {
      name = "${finalAttrs.pname}-exe-test";
      buildInputs = [ finalAttrs.finalPackage.bin ];
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

        touch $out
      '';
    };

    shlibTest = testers.runCommand {
      name = "${finalAttrs.pname}-shlib-test";
      inherit stdenv; # with CC
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        finalAttrs.finalPackage.dev
      ];
      script = ''
        substitute ${./lib_test.c} lib_test.c \
          --replace-fail '#include <liblzf/lzf.h>' '#include <lzf.h>'
        $CC -g lib_test.c -o lib_test \
          $(pkg-config --cflags --libs liblzf)

        ./lib_test >/dev/null

        $CC -g ${./lib_test.c} -o lib_test-namespaced \
          $(pkg-config --cflags --libs liblzf)

        ./lib_test-namespaced >/dev/null

        touch $out
      '';
    };
  };

  meta = {
    changelog =
      "http://cvs.schmorp.de/liblzf/Changes?pathrev=rel-"
      + builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
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

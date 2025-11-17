{
  lib,
  stdenv,
  fetchDebianPatch,
  fetchpatch,
  fetchurl,
  pkg-config,
  testers,
  validatePkgConfig,
  autoconf,
  automake,
  libtool,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "liblzf";
  version = "3.6";

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
    (
      let
        name = "liblzf-3.6-autoconf-20140314.patch";
      in
      fetchpatch {
        inherit name;
        url = "https://src.fedoraproject.org/rpms/liblzf/raw/53da654eead51a24ac81a28e1b1c531eb1afab28/f/${name}";
        hash = "sha256-rkhI8w0HV3fGiDfHiXBzrnxqGDE/Yo5ntePrsscMiyg=";
      }
    )
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    validatePkgConfig
  ];

  preConfigure = ''
    sh ./bootstrap.sh
  '';

  postInstall = ''
    pushd $out/bin
    ln -s lzf unlzf
    popd
  '';

  outputs = [
    "out"
    "dev"
  ];

  passthru.tests = {
    pkgConfigTest = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      version = "${finalAttrs.version}.0";
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

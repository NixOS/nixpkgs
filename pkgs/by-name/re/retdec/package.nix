{ stdenv
, fetchFromGitHub
, fetchpatch
, fetchzip
, writeText
, lib
, openssl
, cmake
, ninja
, autoconf
, automake
, libtool
, pkg-config
, bison
, flex
, groff
, perl
, python3
, ncurses
, time
, upx
, gtest
, libffi
, libxml2
, zlib
, buildEnv
, enableTests ? true
, buildDevTools ? true
, compileYaraPatterns ? false
}:

let
  # all dependencies that are normally fetched during build time (the subdirectories of `deps`)
  # all of these need to be fetched through nix and applied via their <NAME>_URL cmake variable
  capstone = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = "5.0-rc2";
    hash = "sha256-nB7FcgisBa8rRDS3k31BbkYB+tdqA6Qyj9hqCnFW+ME=";
  };
  llvm = fetchFromGitHub {
    owner = "avast-tl";
    repo = "llvm";
    rev = "2a1f3d8a97241c6e91710be8f84cf3cf80c03390";
    hash = "sha256-+v1T0VI9R92ed9ViqsfYZMJtPCjPHCr4FenoYdLuFOU=";
  };
  yaracpp = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v4.2.0-rc1";
    hash = "sha256-WcN6ClYO2d+/MdG06RHx3kN0o0WVAY876dJiG7CwJ8w=";
  };
  yaramod = fetchFromGitHub {
    owner = "avast";
    repo = "yaramod";
    rev = "aa06dd408c492a8f4488774caf2ee105ccc23ab5";
    hash = "sha256-wiD4A+6Jsd7bzGo8mmWnkb7l2XcjEgLCK/A4iW9Zt/A=";

    # yaramod builds yet more dependencies. these need to be installed to "lib"
    postFetch = ''
      (
      cd $out
      shopt -s globstar
      substituteInPlace src/CMakeLists.txt deps/**/CMakeLists.txt \
        --replace-quiet CMAKE_ARGS 'CMAKE_ARGS -DCMAKE_INSTALL_LIBDIR=lib' \
        --replace-quiet '$'{CMAKE_INSTALL_LIBDIR} lib
      )
    '';
  };
  keystone = fetchFromGitHub {
    # only for tests
    owner = "keystone-engine";
    repo = "keystone";
    rev = "d7ba8e378e5284e6384fc9ecd660ed5f6532e922";
    sha256 = "1yzw3v8xvxh1rysh97y0i8y9svzbglx2zbsqjhrfx18vngh0x58f";
  };

  retdec-support-version = "2019-03-08";
  retdec-support =
    { rev = retdec-support-version; } // # for checking the version against the expected version
    fetchzip {
      url = "https://github.com/avast-tl/retdec-support/releases/download/${retdec-support-version}/retdec-support_${retdec-support-version}.tar.xz";
      hash = "sha256-t1tx4MfLW/lwtbO5JQ1nrFBIOeMclq+0dENuXW+ahIM=";
      stripRoot = false;
    };

  # checks the nix dependency "dep" matches that specified in the deps.cmake.
  # if dep.rev is null, the check is disabled.
  # see: https://github.com/avast/retdec/blob/master/cmake/deps.cmake
  check-dep = name: dep:
    ''
      context="$(grep ${name}_URL --after-context 1 cmake/deps.cmake)"
      expected="$(echo "$context" | grep --only-matching '".*"')"
      have="${builtins.toString dep.rev}"

      echo "checking ${name} dependency matches deps.cmake...";
      if [[ -z "$have" ]]; then
        echo "${name} version check disabled"
      elif ! echo "$expected" | grep -q "$have"; then
        printf '%s\n' "${name} version does not match!"  "  nix: $have, expected: $expected"
        false
      fi
    '';

  deps = {
    CAPSTONE = capstone;
    LLVM = llvm;
    YARA = yaracpp;
    YARAMOD = yaramod;
    SUPPORT_PKG = retdec-support;
  } // lib.optionalAttrs enableTests {
    KEYSTONE = keystone;
    GOOGLETEST = gtest.src // { rev = null; };  # null rev disables dep version checking
  };

  # overwrite install-share.py to copy instead of download.
  # we use this so the copy happens at the right time in the build,
  # otherwise, the build process cleans the directory.
  install-share =
    writeText
      "install-share.py"
      ''
        import os, sys, shutil, subprocess

        install_path, arch_url, sha256hash_ref, version = sys.argv[1:]
        support_dir = os.path.join(install_path, 'share', 'retdec', 'support')

        assert os.path.isdir(arch_url), "nix install-share.py expects a path for support url"

        os.makedirs(support_dir, exist_ok=True)
        shutil.copytree(arch_url, support_dir, dirs_exist_ok=True)
        subprocess.check_call(['chmod', '-R', 'u+w', support_dir])
      '';
in
stdenv.mkDerivation (self: {
  pname = "retdec";

  # If you update this you will also need to adjust the versions of the updated dependencies.
  # I've notified upstream about this problem here:
  # https://github.com/avast-tl/retdec/issues/412
  #
  # The dependencies and their sources are listed in this file:
  # https://github.com/avast/retdec/blob/master/cmake/deps.cmake
  version = "5.0";

  src = fetchFromGitHub {
    owner = "avast";
    repo = "retdec";
    tag = "v${self.version}";
    sha256 = "sha256-H4e+aSgdBBbG6X6DzHGiDEIASPwBVNVsfHyeBTQLAKI=";
  };

  patches = [
    # gcc 13 compatibility: https://github.com/avast/retdec/pull/1153
    (fetchpatch {
      url = "https://github.com/avast/retdec/commit/dbaab2c3d17b1eae22c581e8ab6bfefadf4ef6ae.patch";
      hash = "sha256-YqHYPGAGWT4x6C+CpsOSsOIZ+NPM2FBQtGQFs74OUIQ=";
    })
    # aarch64 compatibility: https://github.com/avast/retdec/pull/1195 (not yet merged)
    ./fix-long-double.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    autoconf
    automake
    libtool
    pkg-config
    bison
    flex
    groff
    perl
    python3
  ];

  buildInputs = [
    openssl
    ncurses
    libffi
    libxml2
    zlib
  ] ++ lib.optional self.doInstallCheck gtest;

  cmakeFlags = [
    (lib.cmakeBool "RETDEC_TESTS" self.doInstallCheck) # build tests
    (lib.cmakeBool "RETDEC_DEV_TOOLS" buildDevTools) # build tools e.g. capstone2llvmir, retdectool
    (lib.cmakeBool "RETDEC_COMPILE_YARA" compileYaraPatterns) # build and install compiled patterns
  ] ++ lib.mapAttrsToList (k: v: lib.cmakeFeature "${k}_URL" "${v}") deps;
  # note: *_URL variables are simply passed to ExternalProject_Add and can be file paths
  # see: https://github.com/avast/retdec/blob/master/deps/capstone/CMakeLists.txt#L65

  preConfigure =
    lib.concatLines (lib.mapAttrsToList check-dep deps)
    +
    ''
      cp -v ${install-share} ./support/install-share.py

      # the CMakeLists assume CMAKE_INSTALL_BINDIR, etc are path components but in Nix, they are absolute.
      # therefore, we need to remove the unnecessary CMAKE_INSTALL_PREFIX prepend.
      substituteInPlace ./CMakeLists.txt \
        --replace-fail "''$"{CMAKE_INSTALL_PREFIX}/"''$"{RETDEC_INSTALL_BIN_DIR} "''$"{CMAKE_INSTALL_FULL_BINDIR} \
        --replace-fail "''$"{CMAKE_INSTALL_PREFIX}/"''$"{RETDEC_INSTALL_LIB_DIR} "''$"{CMAKE_INSTALL_FULL_LIBDIR} \

      # --replace "''$"{CMAKE_INSTALL_PREFIX}/"''$"{RETDEC_INSTALL_SUPPORT_DIR} "''$"{RETDEC_INSTALL_SUPPORT_DIR}
      # note! Nix does not set CMAKE_INSTALL_DATADIR to an absolute path, so this replacement would be incorrect

      # similarly for yaramod.
      substituteInPlace deps/yaramod/CMakeLists.txt \
        --replace-fail "''$"{YARAMOD_INSTALL_DIR}/"''$"{CMAKE_INSTALL_LIBDIR} "''$"{YARAMOD_INSTALL_DIR}/lib

      # yara needs write permissions in the generated source directory.
      echo '
        ExternalProject_Add_Step(
          yara chmod WORKING_DIRECTORY ''${YARA_DIR}
          DEPENDEES download COMMAND chmod -R u+w .
        )
      ' >> deps/yara/CMakeLists.txt

      # yara: to support building retdec with ninja.
      # although retdec is built with ninja, the subproject yara is built with make.
      substituteInPlace deps/yara/CMakeLists.txt \
        --replace-fail '$'{YARA_MAKE_PROGRAM} $(command -v make)

      # all vendored dependencies must build their libs into the "lib" subdirectory.
      # retdec's install phase will copy these into the correct Nix output.
      substituteInPlace deps/*/CMakeLists.txt \
        --replace-quiet CMAKE_ARGS 'CMAKE_ARGS -DCMAKE_INSTALL_LIBDIR=lib'

      substituteInPlace src/utils/CMakeLists.txt \
        --replace-warn '$'{RETDEC_GIT_VERSION_TAG} ${self.version} \
        --replace-warn '$'{RETDEC_GIT_COMMIT_HASH} ${self.src.rev}


      # tests: without git history, there is no chance these tests will pass.
      substituteInPlace tests/utils/version_tests.cpp \
        --replace-warn VersionTests DISABLED_VersionTests


      # scripts: patch paths
      substituteInPlace scripts/retdec-utils.py \
        --replace-fail /usr/bin/time ${time} \
        --replace-fail /usr/local/bin/gtime ${time}
      substituteInPlace scripts/retdec-unpacker.py \
        --replace-fail "'upx'" "'${upx}'"
    '';

  doInstallCheck = enableTests;
  installCheckPhase = ''
    runHook preInstallCheck

    ${python3.interpreter} "''${!outputBin}/bin/retdec-tests-runner.py"
    rm -rf $out/bin/__pycache__

    runHook postInstallCheck
  '';


  # static-code patterns are split out since they are rarely needed by end users.
  # from retdec's wiki:
  #   However, these are mainly for older compilers used for testing purposes.
  #   If you want to remove code from newer compilers or some custom libraries,
  #   you have to create your own signature files.
  # see: https://github.com/avast/retdec/wiki/Removing-Statically-Linked-Code
  postFixup = ''
    mkdir -p $dev/lib/retdec
    mv -v $out/share/retdec/cmake $dev/lib/retdec

    yara_dir=share/retdec/support/generic/yara_patterns
    mkdir -p $patterns/$yara_dir
    mv -v $out/$yara_dir/static-code $patterns/$yara_dir
  '';

  outputs = [ "out" "lib" "dev" "patterns" ];

  passthru.full = buildEnv {
    name = "${self.pname}-full-${self.version}";
    inherit (self.finalPackage) meta;
    paths = [ self.finalPackage.out self.finalPackage.patterns ];
    postBuild = ''
      config=$out/share/retdec/decompiler-config.json
      cp -v --remove-destination $(readlink -f $config) $config

      static_code=support/generic/yara_patterns/static-code/
      substituteInPlace $config \
        --replace-fail ./$static_code $out/share/retdec/$static_code
    '';
  };

  passthru.deps = deps;

  meta = with lib; {
    description = "Retargetable machine-code decompiler based on LLVM";
    homepage = "https://retdec.com";
    license = licenses.mit;
    maintainers = with maintainers; [ katrinafyi ];
    platforms = platforms.all;
  };
})

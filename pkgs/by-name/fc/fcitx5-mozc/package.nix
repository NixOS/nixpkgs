{
  bazel_8,
  fcitx5,
  fetchFromGitHub,
  gettext,
  lib,
  mozc,
  nixosTests,
  pkg-config,
  python3,
  stdenv,
  unzip,
  libglvnd,
  libxcrypt-legacy,
  writableTmpDirAsHomeHook,
  lndir,
}:

let
  bazel = bazel_8;

  pname = "fcitx5-mozc";
  version = "3.33.6133";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    fetchSubmodules = true;
    rev = "21c0f040627c91143609a8208c4bbbee0bfe697c";
    hash = "sha256-nFZNU04cbwJWFP1wixzwGYGB0WOmbOOft5yXftI+BFY=";
  };

  nativeBuildInputs = [
    bazel
    gettext
    lndir
    pkg-config
    python3
    unzip
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    fcitx5
    libglvnd
    libxcrypt-legacy
  ];

  includePath = lib.makeIncludePath buildInputs;
  libraryPath = lib.makeLibraryPath buildInputs;

  bazelArgs = [
    "--config=oss_linux"
    "--config=stable_channel"
    "--config=release_build"
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "unix/fcitx5:fcitx5-mozc.so"
    "unix/icons"
  ];

  # vendoring: run "bazel vendor" to download all external dependencies,
  # then clean up sandbox-specific symlinks and markers so the output
  # is reproducible (fixed-output derivation).
  vendorDeps = stdenv.mkDerivation (
    lib.fetchers.normalizeHash { } {
      name = "${pname}-vendor";
      inherit
        src
        version
        nativeBuildInputs
        buildInputs
        ;

      hash = "sha256-5ZU490czheaya7KB7twcIbzZMlzcwVmV68j9upyItHk=";
      outputHashMode = "recursive";

      strictDeps = true;
      __structuredAttrs = true;

      env.USE_BAZEL_VERSION = bazel.version;

      buildPhase = ''
        runHook preBuild

        cd src

        cat >> MODULE.bazel << EOF
        ${mozc.bazelPythonPatch}
        EOF

        bazel vendor --lockfile_mode=update --vendor_dir="$out/vendor_dir" ${lib.escapeShellArgs bazelArgs}
        cp MODULE.bazel.lock "$out"

        echo "removing broken symlinks and markers..."
        find "$out" -type l -lname '/*' -print -delete
        find "$out" -xtype l -print -delete
        rm -vrf "$out"/vendor_dir/*local_python3*

        runHook postBuild
      '';
      dontInstall = true;
      dontFixup = true;
      dontWrapQtApps = true;
    }
  );
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    ;

  strictDeps = true;
  __structuredAttrs = true;

  env.USE_BAZEL_VERSION = bazel.version;

  postPatch = ''
    patchShebangs --build scripts

    cd src

    cat >> MODULE.bazel << EOF
    ${mozc.bazelPythonPatch}
    EOF

    substituteInPlace config.bzl \
      --replace-fail "/usr/lib/mozc" "${mozc}/lib/mozc"

    cp -r --no-preserve=mode "${vendorDeps}"/* .
    substituteInPlace \
      vendor_dir/rules_python*/python/private/py_runtime_info.bzl \
      vendor_dir/rules_python*/python/private/py_executable.bzl \
      vendor_dir/rules_python*/python/private/runtime_env_toolchain.bzl \
      --replace-fail "/usr/bin/env python3" "${lib.getExe python3}"
    patchShebangs --build vendor_dir
    for dir in vendor_dir/*/; do
      echo "pin(\"@@$(basename "$dir")\")"
    done > vendor_dir/VENDOR.bazel
  '';

  buildPhase = ''
    runHook preBuild

    bazel build --lockfile_mode=error --vendor_dir=vendor_dir ${lib.escapeShellArgs bazelArgs}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    PREFIX="$out" ../scripts/install_fcitx5_bazel

    runHook postInstall
  '';

  passthru = {
    inherit vendorDeps;
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) fcitx5;
    };
  };
  meta = {
    description = "Mozc - a Japanese Input Method Editor designed for multi-platform";
    homepage = "https://github.com/fcitx/mozc";
    license = with lib.licenses; [
      asl20 # abseil-cpp
      bsd3 # mozc, breakpad, gtest, gyp, japanese-usage-dictionary, protobuf
      mit # wil
      naist-2003 # IPAdic
      publicDomain # src/data/test/stress_test, Okinawa dictionary
      unicode-30 # src/data/unicode, breakpad
    ];
    maintainers = with lib.maintainers; [
      berberman
      govanify
      musjj
    ];
    platforms = lib.platforms.linux;
  };
}

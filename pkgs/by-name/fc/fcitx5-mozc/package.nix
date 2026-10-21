{
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
  writableTmpDirAsHomeHook,
}:

let
  inherit (mozc) bazel;

  pname = "fcitx5-mozc";
  version = "3.35.6354";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    fetchSubmodules = true;
    rev = "a74b67127d710da4dc6fdbbd17320d04741174de";
    hash = "sha256-ITFhc3IetbFWThMoidIDvMWl2gCxiWVyVwxbLCQBSDI=";
  };

  nativeBuildInputs = [
    bazel
    gettext
    pkg-config
    python3
    unzip
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    fcitx5
  ];

  includePath = lib.makeIncludePath buildInputs;
  libraryPath = lib.makeLibraryPath buildInputs;

  bazelArgs = mozc.bazelCommonArgs ++ [
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "unix/fcitx5:fcitx5-mozc.so"
    "unix/icons"
  ];

  vendorDeps = mozc.mkVendorDeps {
    inherit
      pname
      src
      version
      nativeBuildInputs
      buildInputs
      bazelArgs
      ;
    hash = "sha256-POfx1mq/WL903N03XOHxWlJM/aN+IQWu8Uhgp2VBetI=";
  };
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
  # Work around Bazel's username lookup with sandbox=false and auto-allocate-uids=true.
  env.USER = "nixbld";

  postPatch = ''
    patchShebangs --build scripts

    cd src

    ${mozc.setupBazelVendor vendorDeps}

    substituteInPlace config.bzl \
      --replace-fail "/usr/lib/mozc" "${mozc}/lib/mozc"
  '';

  buildPhase = ''
    runHook preBuild

    bazel build --lockfile_mode=error --vendor_dir=vendor_dir ${lib.escapeShellArgs bazelArgs}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    PREFIX="$out" ../scripts/install_fcitx5_bazel
    install -Dm444 ../LICENSE "$out/share/licenses/$pname/LICENSE"

    iconsDir="$out/share/icons/hicolor/scalable/apps"
    mkdir -p "$iconsDir"
    unzip -q bazel-bin/unix/icons.zip -d icons
    install -Dm444 icons/mozc.svg "$iconsDir/org.fcitx.Fcitx5.fcitx_mozc.svg"
    ln -s org.fcitx.Fcitx5.fcitx_mozc.svg "$iconsDir/fcitx_mozc.svg"
    for icon in alpha_full alpha_half direct hiragana katakana_full katakana_half dictionary properties tool; do
      install -Dm444 "icons/$icon.svg" \
        "$iconsDir/org.fcitx.Fcitx5.fcitx_mozc_$icon.svg"
      ln -s "org.fcitx.Fcitx5.fcitx_mozc_$icon.svg" \
        "$iconsDir/fcitx_mozc_$icon.svg"
    done

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

{
  bazel_9,
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
  bazel = bazel_9;

  pname = "fcitx5-mozc";
  version = "3.34.6239";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    fetchSubmodules = true;
    rev = "35898ee6c4f7424ae73000bbd754510d7ab772d0";
    hash = "sha256-PQtHjZAwo/hImF+7nVEEs85uZbwO1zaXVy+/qbhMY9Q=";
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
    hash = "sha256-l3J2LyB95Scdz9GLC0YrPXg01jJK60woHVm3AdYQ31w=";
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  pkg-config,
  cmake,
  ninja,
  clang,
  python3,
  tdlib,
  tg_owt ? callPackage ./tg_owt.nix { inherit stdenv; },
  qtbase,
  qtsvg,
  qtwayland,
  kcoreaddons,
  lz4,
  xxHash,
  ffmpeg_6,
  protobuf,
  openalSoft,
  minizip,
  range-v3,
  tl-expected,
  hunspell,
  gobject-introspection,
  rnnoise,
  microsoft-gsl,
  boost,
  ada,
  libicns,
  apple-sdk_15,
  nix-update-script,
}:

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

stdenv.mkDerivation (finalAttrs: {
  pname = "telegram-desktop-unwrapped";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-kIiOHXFOjHCE3GaizNvpu8rUCuJKBN5Oi7p0NvHYy04=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # to build bundled libdispatch
    clang
    gobject-introspection
  ];

  buildInputs = [
    qtbase
    qtsvg
    lz4
    xxHash
    ffmpeg_6
    openalSoft
    minizip
    range-v3
    tl-expected
    rnnoise
    tg_owt
    microsoft-gsl
    boost
    ada
    (tdlib.override { tde2eOnly = true; })
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    protobuf
    qtwayland
    kcoreaddons
    hunspell
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
    libicns
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # We're allowed to used the API ID of the Snap package:
    (lib.cmakeFeature "TDESKTOP_API_ID" "611335")
    (lib.cmakeFeature "TDESKTOP_API_HASH" "d524b414d21f4d37f08684c1df41ac9c")
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r ${finalAttrs.meta.mainProgram}.app $out/Applications
    ln -sr $out/{Applications/${finalAttrs.meta.mainProgram}.app/Contents/MacOS,bin}

    runHook postInstall
  '';

  passthru = {
    inherit tg_owt;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "Telegram";
  };
})

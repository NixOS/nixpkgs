{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  substituteAll,
  cmake,
  python3Packages,
  libsForQt5,
  SDL2,
  fmt,
  toml11,
  libunarr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanoboyadvance";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "nba-emu";
    repo = "NanoBoyAdvance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-du3dPTg3OxNTWXDQo2m9W0rJxtrkn+lQSh/XGiu/eGg=";
  };

  patches = [
    (substituteAll {
      src = ./dont-fetch-glad.patch;
      gladSrc = fetchFromGitHub {
        owner = "Dav1dde";
        repo = "glad";
        rev = "v2.0.5";
        hash = "sha256-Ba7nbd0DxDHfNXXu9DLfnxTQTiJIQYSES9CP5Bfq4K0=";
      };
    })
    (fetchpatch {
      name = "fix-darwin-bundle-install-path.patch";
      url = "https://github.com/nba-emu/NanoBoyAdvance/commit/bd07a261141cd1f67b828d20f6d01a97adf91c16.patch";
      hash = "sha256-Nqz35PGfPBZ3Lg6szez4k3R/NkgObNndvbxY8JCY40Y";
    })
  ];

  nativeBuildInputs = [
    cmake
    python3Packages.jinja2
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    SDL2
    fmt
    toml11
    libunarr
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "USE_SYSTEM_FMT" true)
      (lib.cmakeBool "USE_SYSTEM_TOML11" true)
      (lib.cmakeBool "USE_SYSTEM_UNARR" true)
      (lib.cmakeBool "PORTABLE_MODE" false)
    ]
    ++ lib.optionals stdenv.isDarwin [
      (lib.cmakeBool "MACOS_BUILD_APP_BUNDLE" true)
      (lib.cmakeBool "MACOS_BUNDLE_QT" false)
    ];

  meta = {
    description = "Cycle-accurate Nintendo Game Boy Advance emulator";
    homepage = "https://github.com/nba-emu/NanoBoyAdvance";
    license = lib.licenses.gpl3Plus;
    mainProgram = "NanoBoyAdvance";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
  gettext,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "emoji-runner";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "alex1701c";
    repo = "EmojiRunner";
    tag = finalAttrs.version;
    hash = "sha256-Rt7Z0uEbzqRKxV1EpDr//RYaVr3D+Nj+7JS3EAO+hsM=";
  };

  dontWrapQtApps = true;

  buildInputs = with kdePackages; [
    ki18n
    kservice
    krunner
    ktextwidgets
    kcmutils
    kconfigwidgets
  ];

  nativeBuildInputs = [
    cmake
    gettext
    kdePackages.extra-cmake-modules
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_WITH_QT6=ON"
    "-DQT_MAJOR_VERSION=6"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/alex1701c/EmojiRunner/releases/tag/${finalAttrs.version}";
    description = "Search for emojis in Krunner and copy/paste them";
    homepage = "https://github.com/alex1701c/EmojiRunner";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ Kladki ];
    inherit (kdePackages.krunner.meta) platforms;
  };
})

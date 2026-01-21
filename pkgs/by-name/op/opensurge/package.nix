{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  allegro5,
  libglvnd,
  surgescript,
  physfs,
  xorg,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensurge";
  version = "0.6.1.2";

  src = fetchFromGitHub {
    owner = "alemart";
    repo = "opensurge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HvpKZ62mYy7XkZOnIn7QRA2rFVREFnKO1NO83aCR76k=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    allegro5
    libglvnd
    physfs
    surgescript
    xorg.libX11
  ];

  cmakeFlags = [
    "-DGAME_BINDIR=${placeholder "out"}/bin"
    "-DDESKTOP_ICON_PATH=${placeholder "out"}/share/pixmaps"
    "-DDESKTOP_METAINFO_PATH=${placeholder "out"}/share/metainfo"
    "-DDESKTOP_ENTRY_PATH=${placeholder "out"}/share/applications"
    "-DWANT_BUILD_DATE=OFF"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  # Darwin fails with "Critical error: required built-in appearance SystemAppearance not found"
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    mainProgram = "opensurge";
    description = "Fun 2D retro platformer inspired by Sonic games and a game creation system";
    homepage = "https://opensurge2d.org/";
    downloadPage = "https://github.com/alemart/opensurge";
    changelog = "https://github.com/alemart/opensurge/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})

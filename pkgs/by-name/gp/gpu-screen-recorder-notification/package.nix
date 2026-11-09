{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,
  gsettings-desktop-schemas,
  libglvnd,
  libx11,
  libxext,
  libxkbcommon,
  libxrandr,
  libxrender,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  pango,
  pkg-config,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-notification";
  version = "1.3.8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
    tag = finalAttrs.version;
    hash = "sha256-nojlYxNqoB9x8LBNYKERzQzp+l+cALkKYV+ORMZjBlo=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    wayland-scanner
  ];
  buildInputs = [
    libglvnd
    pango
    libx11
    libxrandr
    libxrender
    libxkbcommon
    libxext
    wayland
    gsettings-desktop-schemas
  ];

  mesonBuildType = "release";

  postInstall = ''
    wrapProgram "$out/bin/gsr-notify" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libglvnd ]} $out/bin/.gsr-notify-wrapped
  '';

  passthru = {
    tests.nixos = nixosTests.gpu-screen-recorder;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      AhmedAmr
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gsr-notify";
  };
})

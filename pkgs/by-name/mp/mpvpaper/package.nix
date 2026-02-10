{
  stdenv,
  lib,
  meson,
  ninja,
  wayland,
  wayland-protocols,
  wayland-scanner,
  egl-wayland,
  glew,
  mpv,
  pkg-config,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpvpaper";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "GhostNaN";
    repo = "mpvpaper";
    rev = finalAttrs.version;
    sha256 = "sha256-JTlZSl8CZmWx7YTd0T58pwq10L1GKXNfAw0XlIsz7F8=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    installShellFiles
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    egl-wayland
    glew
    mpv
  ];

  preInstall = ''
    mv ../mpvpaper.man ../mpvpaper.1
  '';

  postInstall = ''
    wrapProgram $out/bin/mpvpaper \
      --prefix PATH : ${lib.makeBinPath [ mpv ]}

    installManPage ../mpvpaper.1
  '';

  meta = {
    description = "Video wallpaper program for wlroots based wayland compositors";
    homepage = "https://github.com/GhostNaN/mpvpaper";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "mpvpaper";
    maintainers = with lib.maintainers; [ atila ];
  };
})

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

stdenv.mkDerivation rec {
  pname = "mpvpaper";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "GhostNaN";
    repo = "mpvpaper";
    rev = version;
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

  meta = with lib; {
    description = "Video wallpaper program for wlroots based wayland compositors";
    homepage = "https://github.com/GhostNaN/mpvpaper";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "mpvpaper";
    maintainers = with maintainers; [ atila ];
  };
}

{
  stdenv,
  lib,
  fetchFromGitHub,
  openssl,
  curl,
  ffmpeg,
  vlc,
  SDL2,
  lame,
  json_c,
  cmake,
  pkg-config,
  ncurses,
  libuuid,
  pandoc,
  pipewire,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ctune";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "An7ar35";
    repo = "ctune";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HGCXtntsCQsWKoTbhRZ71NxfD4rFuYDE2IbGVh0Cj/E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    pandoc
  ];

  buildInputs = [
    openssl
    curl
    ffmpeg
    vlc
    SDL2
    lame
    json_c
    ncurses
    libuuid
    pipewire
  ];

  strictDeps = true;

  cmakeFlags = [
    # Avoid a wrong nested install path location
    # Set to "$out" instead of "$out/$out"
    "-DCMAKE_INSTALL_PREFIX=''"
  ];

  patches = [
    ./cmake_remove_git_check.patch
    ./docs_cmake_fix_man_install_dir.patch
  ];

  meta = {
    description = "Nice terminal nCurses (tui) internet radio player for Linux, browse and search from api.radio-browser.info";
    homepage = "https://github.com/An7ar35/ctune";
    changelog = "https://github.com/An7ar35/ctune/blob/master/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "ctune";
    platforms = lib.platforms.linux;
  };
})

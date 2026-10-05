{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cairo,
  pango,
  pkg-config,
  wayland-protocols,
  glib,
  wayland,
  libxkbcommon,
  makeWrapper,
  wayland-scanner,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "dmenu-wayland";
  version = "0-unstable-2023-05-18";

  src = fetchFromGitHub {
    owner = "nyyManni";
    repo = "dmenu-wayland";
    rev = "a380201dff5bfac2dace553d7eaedb6cea6855f9";
    hash = "sha256-dqFvU2mRYEw7n8Fmbudwi5XMLQ7mQXFkug9D9j4FIrU=";
  };

  outputs = [
    "out"
    "man"
  ];

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    wayland-scanner
  ];
  buildInputs = [
    cairo
    pango
    wayland-protocols
    glib
    wayland
    libxkbcommon
  ];

  patches = [
    # can be removed when https://github.com/nyyManni/dmenu-wayland/pull/23 is included
    (fetchpatch {
      name = "support-cross-compilation.patch";
      url = "https://github.com/nyyManni/dmenu-wayland/commit/3434410de5dcb007539495395f7dc5421923dd3a.patch";
      sha256 = "sha256-im16kU8RWrCY0btYOYjDp8XtfGEivemIPlhwPX0C77o=";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/dmenu-wl_run \
      --prefix PATH : $out/bin
  '';

  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    description = "Efficient dynamic menu for wayland (wlroots)";
    homepage = "https://github.com/nyyManni/dmenu-wayland";
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "dmenu-wl";
  };
}

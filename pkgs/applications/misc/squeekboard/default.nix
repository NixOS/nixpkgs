{ stdenv
, pkgs
, fetchFromGitLab
, cmake
, meson
, ninja
, pkg-config
, gnome3
, glib
, gtk3
, wayland
, wayland-protocols
, rustc
, cargo
, libxml2
, libxkbcommon
, rustPlatform
, makeWrapper
, substituteAll
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "squeekboard";
  version = "1.9.2";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "02jjc9qxzb4iw3vypqdaxzs5mc66zkfmij1yrv72h99acg5s3ncz";
  };

  patches = [
    # Add missing dependency 'gio-unix-2.0' to meson.build.
    # https://source.puri.sm/Librem5/squeekboard/-/merge_requests/356
    (fetchpatch {
      url = "https://source.puri.sm/Librem5/squeekboard/-/merge_requests/356.patch";
      sha256 = "1xi7h2nsrlf7szlj41kj6x1503af9svk5yj19l0q32ln3c40kgfs";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    glib  # for glib-compile-resources
    wayland
    makeWrapper
  ];

  buildInputs = [
    gtk3  # for gio-2.0
    gnome3.gnome-desktop
    wayland
    wayland-protocols
    libxml2
    libxkbcommon
  ];

  cargoSha256 = "00gzw703w16i81yna4winj7gi4w7a1p986ggnx48jvyi0c14mxx0";

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  postFixup = ''
    # Substitute the placeholder created by desktop-in.patch
    substituteInPlace "$out/share/applications/sm.puri.Squeekboard.desktop" \
        --replace "@bindir@" "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Squeekboard is a virtual keyboard supporting Wayland";
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat ];
    platforms = platforms.linux;
  };
}

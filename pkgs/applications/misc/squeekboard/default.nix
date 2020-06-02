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
  version = "1.9.1";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nrihpffr91p3ipif5k5z9vcvkwxk6qy8hp93w13s7gnwl2g93hx";
  };

  patches = [
    # Use absolute exec path in the desktop file.
    # https://source.puri.sm/Librem5/squeekboard/merge_requests/352
    ./desktop-in.patch

    # Remove the unused dependency 'libcroco' the from meson.build.
    # https://source.puri.sm/Librem5/squeekboard/merge_requests/351
    (fetchpatch {
      url = "https://source.puri.sm/Librem5/squeekboard/commit/f473a47eb8f394ab6f36704850e7e2bfa74ce8a1.patch";
      sha256 = "0mlp8c38s4mbza8czf4kdg86kvqw294nbpqfk9apbl92nq0a26zr";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    glib.dev
    gtk3.dev
    wayland
    makeWrapper
  ];

  buildInputs = [
    glib
    gtk3
    gnome3.gnome-desktop
    wayland
    wayland-protocols
    libxml2
    libxkbcommon
  ];

  cargoSha256 = "1fkhj4i2l2hdk9wvld6ryvnm1mxfwx3s555r7n42pg9f5namn1sr";

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

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

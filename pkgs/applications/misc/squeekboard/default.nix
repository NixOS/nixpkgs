{ stdenv
, pkgs
, fetchFromGitLab
, cmake
, meson
, ninja
, pkgconfig
, gnome3
, glib
, gtk3
, wayland
, wayland-protocols
, rustc
, cargo
, libcroco
, libxml2
, libxkbcommon
, rustPlatform
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "squeekboard";
  version = "1.9.1";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "334898c5a5d45a5883654b4f2f07f28ac8f2bfc4";
    sha256 = "1nrihpffr91p3ipif5k5z9vcvkwxk6qy8hp93w13s7gnwl2g93hx";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    rustc
    cargo
    glib.dev
    gtk3.dev
    wayland
    gnome3.gnome-desktop
    makeWrapper
  ];

  buildInputs = [
    glib.dev
    gtk3.dev
    gnome3.gnome-desktop
    wayland
    wayland-protocols
    libcroco
    libxml2
    libxkbcommon
  ];

  cargoSha256 = "1fkhj4i2l2hdk9wvld6ryvnm1mxfwx3s555r7n42pg9f5namn1sr";

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  configurePhase = "meson . _build/";
  buildPhase = ''
    ninja -C _build test
  '';
  installPhase = ''
    runHook preInstall && DESTDIR="$out" ninja -C _build install && runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/bin
    cp _build/src/squeekboard $out/bin/
  '';

  check = false;

  meta = with stdenv.lib; {
    description = "Squeekboard is a virtual keyboard supporting Wayland";
    homepage = https://source.puri.sm/Librem5/squeekboard;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat ];
    platforms = platforms.linux;
  };
}

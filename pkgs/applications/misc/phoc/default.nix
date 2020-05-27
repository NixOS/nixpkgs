{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, libinput
, gnome3
, glib
, gtk3
, wayland
, dbus
, cmake
, libdrm
, libxkbcommon
, wlroots
}:

stdenv.mkDerivation rec {
  pname = "phoc";
  version = "0.1.7";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1007kxap87h1bi79sz45lfb478d93pq0676cr5rnhbanljm1n28n";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    libdrm.dev
    libxkbcommon
    libinput
    glib
    gtk3
    gnome3.gnome-desktop
    gnome3.mutter
    wayland
    wlroots
  ];

  NIX_CFLAGS_COMPILE = "-I${libdrm.dev}/include/libdrm/";

  configurePhase = "meson build --prefix=$out";
  buildPhase = "ninja -C build";
  installPhase = "runHook preInstall && ninja -C build install && runHook postInstall";

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "Wayland compositor for mobile phones like the Librem 5";
    homepage = "https://source.puri.sm/Librem5/phoc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat ];
    platforms = platforms.linux;
  };
}

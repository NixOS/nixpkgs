{ lib
, stdenv
, fetchFromGitHub
, zig
, wayland
, pkg-config
, scdoc
, xwayland
, wayland-protocols
, wlroots
, libxkbcommon
, pixman
, udev
, libevdev
, libinput
, libGL
, xwaylandSupport ? true, libX11
}:

stdenv.mkDerivation rec {
  pname = "river";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "riverwm";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mysj6fmgiwzrfzm1rk09k4xa9qiqsdwvwr59b4rs010c1gsllwk";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig wayland xwayland scdoc pkg-config ];

  buildInputs = [
    wayland-protocols
    wlroots
    libxkbcommon
    pixman
    udev
    libevdev
    libinput
    libGL
  ] ++ lib.optional xwaylandSupport libX11;

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline ${lib.optionalString xwaylandSupport "-Dxwayland"} -Dman-pages --prefix $out install
    runHook postInstall
  '';

  /* Builder patch install dir into river to get default config
     When installFlags is removed, river becomes half broken.
     See https://github.com/riverwm/river/blob/7ffa2f4b9e7abf7d152134f555373c2b63ccfc1d/river/main.zig#L56
  */
  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/ifreund/river";
    description = "A dynamic tiling wayland compositor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}

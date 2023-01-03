{ lib
, stdenv
, fetchFromGitHub
, zig
, wayland
, pkg-config
, scdoc
, xwayland
, wayland-protocols
, wlroots_0_16
, libxkbcommon
, pixman
, udev
, libevdev
, libinput
, libGL
, libX11
, xwaylandSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "river";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "riverwm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BrOZch6wkiBB4rk0M7Aoy8sZh8uOTQFOPxd3xLyy/K0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig wayland xwayland scdoc pkg-config ];

  buildInputs = [
    wayland-protocols
    wlroots_0_16
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
    install contrib/river.desktop -Dt $out/share/wayland-sessions
    runHook postInstall
  '';

  /* Builder patch install dir into river to get default config
    When installFlags is removed, river becomes half broken.
    See https://github.com/riverwm/river/blob/7ffa2f4b9e7abf7d152134f555373c2b63ccfc1d/river/main.zig#L56
  */
  installFlags = [ "DESTDIR=$(out)" ];

  passthru.providedSessions = ["river"];

  meta = with lib; {
    homepage = "https://github.com/ifreund/river";
    description = "A dynamic tiling wayland compositor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fortuneteller2k adamcstephens ];
  };
}

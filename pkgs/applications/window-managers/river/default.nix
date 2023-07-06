{ lib
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

zig.buildZigPackage rec {
  pname = "river";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "riverwm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cIcO6owM6eYn+obYVaBOVQpnBx4++KOqQk5Hzo3GcNs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ wayland xwayland scdoc pkg-config ];

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
  strictDeps = false; # This needs to be disabled for the build to work.

  preBuild = ''
    export HOME=$TMPDIR
  '';

  zigBuildFlags = [ "-Dman-pages" ] ++ lib.optional xwaylandSupport "-Dxwayland";

  postInstall = ''
    install contrib/river.desktop -Dt $out/share/wayland-sessions
  '';

  /* Builder patch install dir into river to get default config
    When installFlags is removed, river becomes half broken.
    See https://github.com/riverwm/river/blob/7ffa2f4b9e7abf7d152134f555373c2b63ccfc1d/river/main.zig#L56
  */
  installFlags = [ "DESTDIR=$(out)" ];

  passthru.providedSessions = [ "river" ];

  meta = with lib; {
    changelog = "https://github.com/ifreund/river/releases/tag/v${version}";
    homepage = "https://github.com/ifreund/river";
    description = "A dynamic tiling wayland compositor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fortuneteller2k adamcstephens rodrgz ];
  };
}

{ lib, stdenv, fetchzip
, pkg-config, bmake
, cairo, glib, libevdev, libinput, libxkbcommon, linux-pam, pango, pixman
, libucl, wayland, wayland-protocols, wlroots, mesa
, features ? {
    gammacontrol = true;
    layershell   = true;
    screencopy   = true;
    xwayland     = true;
  }
}:

stdenv.mkDerivation rec {
  pname = "hikari";
  version = "2.3.3";

  src = fetchzip {
    url = "https://hikari.acmelabs.space/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-5Ug0U3ESC5F/gj7bahnLYkeY/weSCj0QASwdFuWwdMI=";
  };

  nativeBuildInputs = [ pkg-config bmake ];

  buildInputs = [
    cairo
    glib
    libevdev
    libinput
    libxkbcommon
    linux-pam
    pango
    pixman
    libucl
    mesa # for libEGL
    wayland
    wayland-protocols
    wlroots
  ];

  enableParallelBuilding = true;

  makeFlags = with lib; [ "PREFIX=$(out)" ]
    ++ optional stdenv.isLinux "WITH_POSIX_C_SOURCE=YES"
    ++ mapAttrsToList (feat: enabled:
         optionalString enabled "WITH_${toUpper feat}=YES"
       ) features;

  postPatch = ''
    # Can't suid in nix store
    # Run hikari as root (it will drop privileges as early as possible), or create
    # a systemd unit to give it the necessary permissions/capabilities.
    substituteInPlace Makefile --replace '4555' '555'

    sed -i 's@<drm_fourcc.h>@<libdrm/drm_fourcc.h>@' src/*.c
  '';

  meta = with lib; {
    description = "Stacking Wayland compositor which is actively developed on FreeBSD but also supports Linux";
    homepage    = "https://hikari.acmelabs.space";
    license     = licenses.bsd2;
    platforms   = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [ jpotier ];
  };
}

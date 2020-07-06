{ stdenv, fetchzip,
  pkgconfig, bmake,
  cairo, glib, libevdev, libinput, libxkbcommon, linux-pam, pango, pixman,
  libucl, wayland, wayland-protocols, wlroots,
  features ? {
    gammacontrol = true;
    layershell   = true;
    screencopy   = true;
    xwayland     = true;
  }
}:

let
  pname = "hikari";
  version = "2.0.4";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://hikari.acmelabs.space/releases/${pname}-${version}.tar.gz";
    sha256 = "0arm2zmiqf63a7a3nwcqf88lsk79n0ycdqqgz0c2wafvdxl23v3d";
  };

  nativeBuildInputs = [ pkgconfig bmake ];

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
    wayland
    wayland-protocols
    wlroots
  ];

  enableParallelBuilding = true;

  # Must replace GNU Make by bmake
  buildPhase = with stdenv.lib; concatStringsSep " " (
    [ "bmake" "-j$NIX_BUILD_CORES" "PREFIX=$out" ]
    ++ optional stdenv.isLinux "WITH_POSIX_C_SOURCE=YES"
    ++ mapAttrsToList (feat: enabled:
         optionalString enabled "WITH_${toUpper feat}=YES"
       ) features
  );

  # Can't suid in nix store
  # Run hikari as root (it will drop privileges as early as possible), or create
  # a systemd unit to give it the necessary permissions/capabilities.
  patchPhase = ''
    substituteInPlace Makefile --replace '4555' '555'
  '';

  installPhase = ''
    bmake \
      PREFIX=$out \
      install
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Stacking Wayland compositor which is actively developed on FreeBSD but also supports Linux";
    homepage    = "https://hikari.acmelabs.space";
    license     = licenses.bsd2;
    platforms   = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [ jpotier ];
  };
}

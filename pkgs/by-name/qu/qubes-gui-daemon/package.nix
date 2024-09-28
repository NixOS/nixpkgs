{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorg,
  libconfig,
  libnotify,
  glib,
  qubes-core-vchan-xen,
  qubes-gui-common,
  qubes-linux-utils,
  qubes-vmm-xen,
  help2man,
  pulseaudio,
  qubes-core-qubesdb,
  python3,
  runCommand,
  xwayland,
  makeWrapper,
}:
let
  inherit (python3.pkgs) wrapPython xcffib qubes-imgconverter;

  version = "4.3.3";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-gui-daemon";
    rev = "refs/tags/v${version}";
    hash = "sha256-m/a/JrDd3na7pKuYW+p+J/FoDx0bLeKHtO/QB+c88q0=";
  };
  daemon = stdenv.mkDerivation {
    inherit version src;
    name = "qubes-gui-daemon";

    patches = [
      # Daemon crashes on NixOS without this patch. Submitted to upstream
      # https://github.com/QubesOS/qubes-gui-daemon/pull/148
      ./0001-fix-make-shmoverride-initfirst.patch
    ];

    nativeBuildInputs = [
      pkg-config
      help2man
      wrapPython
    ];

    buildInputs = [
      xorg.libX11.dev
      xorg.libxcb.dev
      xorg.xcbutil.dev
      xorg.libXrandr.dev
      libnotify.dev
      glib
      libconfig
      qubes-core-vchan-xen
      qubes-gui-common
      qubes-linux-utils
      qubes-core-qubesdb
      qubes-vmm-xen.dev
      pulseaudio
    ];

    buildFlags = ["all"];

    postInstall = ''
      mv $out/usr/* $out/
      mv $out/lib64/* $out/lib
      rm -d $out/{usr,lib64}

      substituteInPlace $out/etc/xdg/autostart/qubes-{icon-receiver,screen-layout-watches}.desktop \
        --replace-fail "Exec=/usr/" "$out/"
      substituteInPlace $out/lib/qubes/icon-receiver \
        --replace-fail "#!/usr/bin/python3" "#!/usr/bin/env python3"
      wrapPythonProgramsIn $out/lib/qubes "${qubes-imgconverter}" "${xcffib}"
    '';

    # Package setups fortification by itself, nixos flags cause "_FORTIFY_SOURCE redefined" error
    hardeningDisable = ["fortify"];

    makeFlags = [ "DESTDIR=$(out)" ];
  };
  # TODO: Patch xwayland derivation instead, and pass wrapper flags here?
  xwayland-patched = runCommand "xwayland-qubes" {
    nativeBuildInputs = [
      makeWrapper
    ];
  } ''
    mkdir -p $out
    cp -r ${xwayland}/* $out/
    chmod -R a+w $out/bin

    wrapProgram $out/bin/Xwayland \
      --prefix LD_PRELOAD : ${daemon}/lib/qubes-gui-daemon/shmoverride.so
    substituteInPlace $out/share/applications/org.freedesktop.Xwayland.desktop \
      --replace-fail "Exec=${xwayland}/bin/Xwayland" "Exec=$out/bin/Xwayland"
  '';
in
daemon.overrideAttrs {
  passthru = {
    xwayland = xwayland-patched;
  };

  meta = {
    description = "Qubes GUID and Xorg LD_PRELOAD payload";
    homepage = "https://qubes-os.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lach sigmasquadron ];
    platforms = lib.platforms.linux;
  };
}

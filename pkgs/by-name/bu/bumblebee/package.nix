# The bumblebee package allows a program to be rendered on an
# dedicated video card by spawning an additional X11 server and
# streaming the results via VirtualGL or primus to the primary server.

# The package is rather chaotic; it's also quite recent.
# As it may change a lot, some of the hacks in this nix expression
# will hopefully not be needed in the future anymore.

# To test:
# 1. make sure that the 'bbswitch' kernel module is installed,
# 2. then run 'bumblebeed' as root
# 3. Then either 'optirun glxinfo' or 'primusrun glxinfo' as user.
#
# The glxinfo output should indicate the Nvidia driver is being used
# and all expected extensions are supported.
#
# To use at startup, see hardware.bumblebee options.

{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  pkg-config,
  help2man,
  makeWrapper,
  glib,
  libbsd,
  libX11,
  xorgserver,
  kmod,
  xf86videonouveau,
  nvidia_x11 ? linuxPackages.nvidia_x11,
  linuxPackages,
  pkgsi686Linux,
  virtualgl,
  libglvnd,
  autoreconfHook,
  # The below should only be non-null in a x86_64 system. On a i686
  # system the above nvidia_x11 and virtualgl will be the i686 packages.
  # TODO: Confusing. Perhaps use "SubArch" instead of i686?
  nvidia_x11_i686 ?
    if stdenv.hostPlatform.system == "x86_64-linux" then
      pkgsi686Linux.linuxPackages.nvidia_x11.override { libsOnly = true; }
    else
      null,
  libglvnd_i686 ?
    if stdenv.hostPlatform.system == "x86_64-linux" then pkgsi686Linux.libglvnd else null,
  useDisplayDevice ? false,
  extraNvidiaDeviceOptions ? "",
  extraNouveauDeviceOptions ? "",
  useNvidia ? true,
}:

let
  nvidia_x11s = [
    nvidia_x11
  ]
  ++ lib.optional nvidia_x11.useGLVND libglvnd
  ++ lib.optionals (nvidia_x11_i686 != null) (
    [ nvidia_x11_i686 ] ++ lib.optional nvidia_x11_i686.useGLVND libglvnd_i686
  );

  nvidiaLibs = lib.makeLibraryPath nvidia_x11s;

  bbdPath = lib.makeBinPath [
    kmod
    xorgserver
  ];

  xmodules = lib.concatStringsSep "," (
    map (x: "${x.out or x}/lib/xorg/modules") (
      [ xorgserver ] ++ lib.optional (!useNvidia) xf86videonouveau
    )
  );

  modprobePatch = fetchpatch {
    url = "https://github.com/Bumblebee-Project/Bumblebee/commit/1ada79fe5916961fc4e4917f8c63bb184908d986.patch";
    sha256 = "02vq3vba6nx7gglpjdfchws9vjhs1x02a543yvqrxqpvvdfim2x2";
  };
  libkmodPatch = fetchpatch {
    url = "https://github.com/Bumblebee-Project/Bumblebee/commit/deceb14cdf2c90ff64ebd1010a674305464587da.patch";
    sha256 = "00c05i5lxz7vdbv445ncxac490vbl5g9w3vy3gd71qw1f0si8vwh";
  };
  gcc10Patch = fetchpatch {
    url = "https://github.com/Bumblebee-Project/Bumblebee/commit/f94a118a88cd76e2dbea33d735bd53cf54b486a1.patch";
    hash = "sha256-3b5tLoMrGYSdg9Hz5bh0c44VIrbSZrY56JpWEyU/Pik=";
  };

in
stdenv.mkDerivation rec {
  pname = "bumblebee";
  version = "3.2.1";

  src = fetchurl {
    url = "https://www.bumblebee-project.org/${pname}-${version}.tar.gz";
    sha256 = "03p3gvx99lwlavznrpg9l7jnl1yfg2adcj8jcjj0gxp20wxp060h";
  };

  patches = [
    ./nixos.patch

    modprobePatch
    libkmodPatch
    gcc10Patch
  ];

  # By default we don't want to use a display device
  nvidiaDeviceOptions =
    lib.optionalString (!useDisplayDevice) ''
      # Disable display device
      Option "UseEDID" "false"
      Option "UseDisplayDevice" "none"
    ''
    + extraNvidiaDeviceOptions;

  nouveauDeviceOptions = extraNouveauDeviceOptions;

  # the have() function is deprecated and not available to bash completions the
  # way they are currently loaded in NixOS, so use _have. See #10936
  postPatch = ''
    substituteInPlace scripts/bash_completion/bumblebee \
      --replace "have optirun" "_have optirun"
  '';

  preConfigure = ''
    # Apply configuration options
    substituteInPlace conf/xorg.conf.nvidia \
      --subst-var nvidiaDeviceOptions

    substituteInPlace conf/xorg.conf.nouveau \
      --subst-var nouveauDeviceOptions
  '';

  # Build-time dependencies of bumblebeed and optirun.
  # Note that it has several runtime dependencies.
  buildInputs = [
    libX11
    glib
    libbsd
    kmod
  ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
    help2man
    autoreconfHook
  ];

  # The order of LDPATH is very specific: First X11 then the host
  # environment then the optional sub architecture paths.
  #
  # The order for MODPATH is the opposite: First the environment that
  # includes the acceleration driver. As this is used for the X11
  # server, which runs under the host architecture, this does not
  # include the sub architecture components.
  configureFlags = [
    "--with-udev-rules=$out/lib/udev/rules.d"
    # Don't use a special group, just reuse wheel.
    "CONF_GID=wheel"
    # see #10282
    #"CONF_PRIMUS_LD_PATH=${primusLibs}"
  ]
  ++ lib.optionals useNvidia [
    "CONF_LDPATH_NVIDIA=${nvidiaLibs}"
    "CONF_MODPATH_NVIDIA=${nvidia_x11.bin}/lib/xorg/modules"
  ];

  CFLAGS = [
    "-DX_MODULE_APPENDS=\\\"${xmodules}\\\""
  ];

  postInstall = ''
    wrapProgram "$out/sbin/bumblebeed" \
      --prefix PATH : "${bbdPath}"

    wrapProgram "$out/bin/optirun" \
      --prefix PATH : "${virtualgl}/bin"
  '';

  meta = with lib; {
    description = "Daemon for managing Optimus videocards (power-on/off, spawns xservers)";
    homepage = "https://github.com/Bumblebee-Project/Bumblebee";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

{
  addOpenGLRunpath,
  autoPatchelfHook,
  lib,
  makeWrapper,
  requireFile,
  runCommand,
  stdenv,
  symlinkJoin,
  # arguments from default.nix
  lang,
  meta,
  name,
  src,
  version,
  # dependencies
  alsa-lib,
  cudaPackages,
  cups,
  dbus,
  flite,
  fontconfig,
  freetype,
  gcc-unwrapped,
  glib,
  gmpxx,
  keyutils,
  libGL,
  libGLU,
  libpcap,
  libtins,
  libuuid,
  libxkbcommon,
  libxml2,
  llvmPackages_12,
  matio,
  mpfr,
  ncurses,
  opencv4,
  openjdk11,
  openssl,
  pciutils,
  tre,
  unixODBC,
  xcbutilimage,
  xcbutilkeysyms,
  xkeyboard_config,
  xorg,
  zlib,
  # options
  cudaSupport,
}:

let
  cudaEnv = symlinkJoin {
    name = "mathematica-cuda-env";
    paths = with cudaPackages; [
      cuda_cudart
      cuda_nvcc
      libcublas
      libcufft
      libcurand
      libcusparse
    ];
    postBuild = ''
      if [ ! -e $out/lib/libcuda.so ]; then
          ln -s ${addOpenGLRunpath.driverLink}/lib/libcuda.so $out/lib
      fi
      ln -s lib $out/lib64
    '';
  };

in
stdenv.mkDerivation {
  inherit
    meta
    name
    src
    version
    ;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ] ++ lib.optional cudaSupport addOpenGLRunpath;

  buildInputs =
    [
      alsa-lib
      cups.lib
      dbus
      flite
      fontconfig
      freetype
      glib
      gmpxx
      keyutils.lib
      libGL
      libGLU
      libpcap
      libtins
      libuuid
      libxkbcommon
      libxml2
      llvmPackages_12.libllvm.lib
      matio
      mpfr
      ncurses
      opencv4
      openjdk11
      openssl
      pciutils
      tre
      unixODBC
      xcbutilimage
      xcbutilkeysyms
      xkeyboard_config
    ]
    ++ (with xorg; [
      libICE
      libSM
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXinerama
      libXmu
      libXrandr
      libXrender
      libXtst
      libxcb
    ])
    ++ lib.optional cudaSupport cudaEnv;

  wrapProgramFlags =
    [
      "--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          dbus
          gcc-unwrapped.lib
          zlib
        ]
      }"
      "--prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}"
      # Fix libQt errors - #96490
      "--set USE_WOLFRAM_LD_LIBRARY_PATH 1"
      # Fix xkeyboard config path for Qt
      "--set QT_XKB_CONFIG_ROOT ${xkeyboard_config}/share/X11/xkb"
      # if wayland isn't supported we fail over to xcb
      # see https://github.com/qt/qtbase/blob/35d0f012ee9b95e8cf3563a41d710ff3c023d841/src/gui/kernel/qguiapplication.cpp#L1218
      "--set QT_QPA_PLATFORM wayland;xcb"
    ]
    ++ lib.optionals cudaSupport [
      "--set CUDA_PATH ${cudaEnv}"
      "--set NVIDIA_DRIVER_LIBRARY_PATH ${addOpenGLRunpath.driverLink}/lib/libnvidia-tls.so"
      "--set CUDA_LIBRARY_PATH ${addOpenGLRunpath.driverLink}/lib/libcuda.so"
    ];

  unpackPhase = ''
    runHook preUnpack

    # Find offset from file
    offset=$(${stdenv.shell} -c "$(grep -axm1 -e 'offset=.*' $src); echo \$offset" $src)
    tail -c +$(($offset + 1)) $src | tar -xf -

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    cd "$TMPDIR/Unix/Installer"

    mkdir -p "$out/lib/udev/rules.d"

    # Set name of installer file
    if [ -f "MathInstaller" ]; then
      INSTALLER="MathInstaller"
    else
      INSTALLER="WolframInstaller"
    fi
    # Patch Installer's shebangs and udev rules dir
    patchShebangs $INSTALLER
    substituteInPlace $INSTALLER \
      --replace /etc/udev/rules.d $out/lib/udev/rules.d

    # Remove PATH restriction, root and avahi daemon checks, and hostname call
    sed -i '
      s/^\s*PATH=/# &/
      s/isRoot="false"/# &/
      s/^\s*checkAvahiDaemon$/:/
      s/^\s*installBundledInstall$/:/
      s/`hostname`/""/
    ' $INSTALLER

    # NOTE: some files placed under HOME may be useful
    XDG_DATA_HOME="$out/share" HOME="$TMPDIR/home" vernierLink=y \
      ./$INSTALLER -execdir="$out/bin" -targetdir="$out/libexec/Mathematica" -auto -verbose -createdir=y

    # Check if Installer produced any errors
    errLog="$out/libexec/Mathematica/InstallErrors"
    if [ -f "$errLog" ]; then
      echo "Installation errors:"
      cat "$errLog"
      return 1
    fi

    runHook postInstall
  '';

  preFixup = ''
    for bin in $out/libexec/Mathematica/Executables/*; do
      wrapProgram "$bin" ''${wrapProgramFlags[@]}
    done
  '';

  dontConfigure = true;
  dontBuild = true;

  # This is primarily an IO bound build; there's little benefit to building remotely
  preferLocalBuild = true;

  # All binaries are already stripped
  dontStrip = true;

  # NOTE: Some deps are still not found; ignore for now
  autoPatchelfIgnoreMissingDeps = true;
}

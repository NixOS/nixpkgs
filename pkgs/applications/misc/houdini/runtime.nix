{ lib, stdenv, requireFile, zlib, libpng, libSM, libICE, fontconfig, xorg, libGLU, libGL, alsa-lib
, dbus, xkeyboardconfig, nss, nspr, expat, pciutils, libxkbcommon, bc, addOpenGLRunpath
}:

let
  # NOTE: Some dependencies only show in errors when run with QT_DEBUG_PLUGINS=1
  ld_library_path = builtins.concatStringsSep ":" [
    "${stdenv.cc.cc.lib}/lib64"
    (lib.makeLibraryPath [
      libGLU
      libGL
      xorg.libXmu
      xorg.libXi
      xorg.libXext
      xorg.libX11
      xorg.libXrender
      xorg.libXcursor
      xorg.libXfixes
      xorg.libXrender
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXtst
      xorg.libxcb
      xorg.libXScrnSaver
      alsa-lib
      fontconfig
      libSM
      libICE
      zlib
      libpng
      dbus
      addOpenGLRunpath.driverLink
      nss
      nspr
      expat
      pciutils
      libxkbcommon
    ])
  ];
  license_dir = "~/.config/houdini";
in
stdenv.mkDerivation rec {
  version = "18.0.460";
  pname = "houdini-runtime";
  src = requireFile rec {
    name = "houdini-${version}-linux_x86_64_gcc6.3.tar.gz";
    sha256 = "18rbwszcks2zfn9zbax62rxmq50z9mc3h39b13jpd39qjqdd3jsd";
    url = meta.homepage;
  };

  buildInputs = [ bc ];
  installPhase = ''
    patchShebangs houdini.install
    mkdir -p $out
    sed -i "s|/usr/lib/sesi|${license_dir}|g" houdini.install
    ./houdini.install --install-houdini \
                      --no-install-menus \
                      --no-install-bin-symlink \
                      --auto-install \
                      --no-root-check \
                      --accept-EULA \
                      $out
    echo -e "localValidatorDir = ${license_dir}\nlicensingMode = localValidator" > $out/houdini/Licensing.opt
    sed -i "s|/usr/lib/sesi|${license_dir}|g" $out/houdini/sbin/sesinetd_safe
    sed -i "s|/usr/lib/sesi|${license_dir}|g" $out/houdini/sbin/sesinetd.startup
    echo "export LD_LIBRARY_PATH=${ld_library_path}" >> $out/bin/app_init.sh
    echo "export QT_XKB_CONFIG_ROOT="${xkeyboardconfig}/share/X11/xkb"" >> $out/bin/app_init.sh
    echo "export LD_LIBRARY_PATH=${ld_library_path}" >> $out/houdini/sbin/app_init.sh
    echo "export QT_XKB_CONFIG_ROOT="${xkeyboardconfig}/share/X11/xkb"" >> $out/houdini/sbin/app_init.sh
  '';
  postFixup = ''
    INTERPRETER="$(cat "$NIX_CC"/nix-support/dynamic-linker)"
    for BIN in $(find $out/bin -type f -executable); do
      if patchelf $BIN 2>/dev/null ; then
        echo "Patching ELF $BIN"
        patchelf --set-interpreter "$INTERPRETER" "$BIN"
      fi
    done
  '';
  meta = {
    description = "3D animation application software";
    homepage = "https://www.sidefx.com";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ]; # requireFile src's should be excluded
    maintainers = with lib.maintainers; [ canndrew kwohlfahrt ];
  };
}

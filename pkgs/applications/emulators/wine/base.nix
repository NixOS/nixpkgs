{ stdenv, lib, pkgArches, callPackage, makeSetupHook,
  pname, version, src, mingwGccs, monos, geckos, platforms,
  bison, flex, fontforge, makeWrapper, pkg-config,
  autoconf, hexdump, perl, nixosTests,
  supportFlags,
  patches,
  vkd3dArches,
  moltenvk,
  buildScript ? null, configureFlags ? [], mainProgram ? "wine"
}:

with import ./util.nix { inherit lib; };

let
  patches' = patches;
  prevName = pname;
  prevPlatforms = platforms;
  prevConfigFlags = configureFlags;
  setupHookDarwin = makeSetupHook {
    name = "darwin-mingw-hook";
    substitutions = {
      darwinSuffixSalt = stdenv.cc.suffixSalt;
      mingwGccsSuffixSalts = map (gcc: gcc.suffixSalt) mingwGccs;
    };
  } ./setup-hook-darwin.sh;
in
stdenv.mkDerivation ((lib.optionalAttrs (buildScript != null) {
  builder = buildScript;
}) // (lib.optionalAttrs stdenv.isDarwin {
  postConfigure = ''
    # dynamic fallback, so this shouldn’t cause problems for older versions of macOS and will
    # provide additional functionality on newer ones. This can be removed once the x86_64-darwin
    # SDK is updated.
    sed 's|/\* #undef HAVE_MTLDEVICE_REGISTRYID \*/|#define HAVE_MTLDEVICE_REGISTRYID 1|' \
      -i include/config.h
  '';
  postBuild = ''
    # The Wine preloader must _not_ be linked to any system libraries, but `NIX_LDFLAGS` will link
    # to libintl, libiconv, and CoreFoundation no matter what. Delete the one that was built and
    # rebuild it with empty NIX_LDFLAGS.
    rm loader/wine64-preloader
    make loader/wine64-preloader NIX_LDFLAGS="" NIX_LDFLAGS_${stdenv.cc.suffixSalt}=""
  '';
}) // rec {
  inherit version src;

  pname = prevName + lib.optionalString supportFlags.waylandSupport "wayland";

  # Fixes "Compiler cannot create executables" building wineWow with mingwSupport
  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    fontforge
    makeWrapper
    pkg-config

    # Required by staging
    autoconf
    hexdump
    perl
  ]
  ++ lib.optionals supportFlags.mingwSupport (mingwGccs
    ++ lib.optional stdenv.isDarwin setupHookDarwin);

  buildInputs = toBuildInputs pkgArches (with supportFlags; (pkgs:
  [ pkgs.freetype pkgs.perl pkgs.libunwind ]
  ++ lib.optional stdenv.isLinux         pkgs.libcap
  ++ lib.optional stdenv.isDarwin        pkgs.libinotify-kqueue
  ++ lib.optional cupsSupport            pkgs.cups
  ++ lib.optional gettextSupport         pkgs.gettext
  ++ lib.optional dbusSupport            pkgs.dbus
  ++ lib.optional openalSupport          pkgs.openal
  ++ lib.optional cairoSupport           pkgs.cairo
  ++ lib.optional odbcSupport            pkgs.unixODBC
  ++ lib.optional netapiSupport          pkgs.samba4
  ++ lib.optional cursesSupport          pkgs.ncurses
  ++ lib.optional vaSupport              pkgs.libva
  ++ lib.optional pcapSupport            pkgs.libpcap
  ++ lib.optional v4lSupport             pkgs.libv4l
  ++ lib.optional saneSupport            pkgs.sane-backends
  ++ lib.optional gphoto2Support         pkgs.libgphoto2
  ++ lib.optional krb5Support            pkgs.libkrb5
  ++ lib.optional ldapSupport            pkgs.openldap
  ++ lib.optional fontconfigSupport      pkgs.fontconfig
  ++ lib.optional alsaSupport            pkgs.alsa-lib
  ++ lib.optional pulseaudioSupport      pkgs.libpulseaudio
  ++ lib.optional (xineramaSupport && !waylandSupport) pkgs.xorg.libXinerama
  ++ lib.optional udevSupport            pkgs.udev
  ++ lib.optional vulkanSupport          (if stdenv.isDarwin then moltenvk else pkgs.vulkan-loader)
  ++ lib.optional sdlSupport             pkgs.SDL2
  ++ lib.optional usbSupport             pkgs.libusb1
  ++ vkd3dArches
  ++ lib.optionals gstreamerSupport      (with pkgs.gst_all_1;
    [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav
    (gst-plugins-bad.override { enableZbar = false; }) ])
  ++ lib.optionals gtkSupport    [ pkgs.gtk3 pkgs.glib ]
  ++ lib.optionals openclSupport [ pkgs.opencl-headers pkgs.ocl-icd ]
  ++ lib.optionals tlsSupport    [ pkgs.openssl pkgs.gnutls ]
  ++ lib.optionals (openglSupport && !stdenv.isDarwin) [ pkgs.libGLU pkgs.libGL pkgs.mesa.osmesa pkgs.libdrm ]
  ++ lib.optionals stdenv.isDarwin (with pkgs.buildPackages.darwin.apple_sdk.frameworks; [
     CoreServices Foundation ForceFeedback AppKit OpenGL IOKit DiskArbitration Security
     ApplicationServices AudioToolbox CoreAudio AudioUnit CoreMIDI OpenAL OpenCL Cocoa Carbon
  ])
  ++ lib.optionals (stdenv.isLinux && !waylandSupport) (with pkgs.xorg; [
     libX11 libXi libXcursor libXrandr libXrender libXxf86vm libXcomposite libXext
  ])
  ++ lib.optionals waylandSupport (with pkgs; [
     wayland libxkbcommon wayland-protocols wayland.dev libxkbcommon.dev
  ])));

  patches = [ ]
    # Wine requires `MTLDevice.registryID` for `winemac.drv`, but that property is not available
    # in the 10.12 SDK (current SDK on x86_64-darwin). Work around that by using selector syntax.
    ++ lib.optional stdenv.isDarwin ./darwin-metal-compat.patch
    ++ patches';

  configureFlags = prevConfigFlags
    ++ lib.optionals supportFlags.waylandSupport [ "--with-wayland" ]
    ++ lib.optionals supportFlags.vulkanSupport [ "--with-vulkan" ]
    ++ lib.optionals supportFlags.vkd3dSupport [ "--with-vkd3d" ]
    ++ lib.optionals (stdenv.isDarwin && !supportFlags.xineramaSupport) [ "--without-x" ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = toString (map (path: "-rpath " + path) (
      map (x: "${lib.getLib x}/lib") ([ stdenv.cc.cc ] ++ buildInputs)
      # libpulsecommon.so is linked but not found otherwise
      ++ lib.optionals supportFlags.pulseaudioSupport (map (x: "${lib.getLib x}/lib/pulseaudio")
          (toBuildInputs pkgArches (pkgs: [ pkgs.libpulseaudio ])))
      ++ lib.optionals supportFlags.waylandSupport (map (x: "${lib.getLib x}/share/wayland-protocols")
          (toBuildInputs pkgArches (pkgs: [ pkgs.wayland-protocols ])))
    ));

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  ## FIXME
  # Add capability to ignore known failing tests
  # and enable doCheck
  doCheck = false;

  postInstall = let
    links = prefix: pkg: "ln -s ${pkg} $out/${prefix}/${pkg.name}";
  in lib.optionalString supportFlags.embedInstallers ''
    mkdir -p $out/share/wine/gecko $out/share/wine/mono/
    ${lib.strings.concatStringsSep "\n"
          ((map (links "share/wine/gecko") geckos)
        ++ (map (links "share/wine/mono")  monos))}
  '' + lib.optionalString supportFlags.gstreamerSupport ''
    # Wrapping Wine is tricky.
    # https://github.com/NixOS/nixpkgs/issues/63170
    # https://github.com/NixOS/nixpkgs/issues/28486
    # The main problem is that wine-preloader opens and loads the wine(64) binary, and
    # breakage occurs if it finds a shell script instead of the real binary. We solve this
    # by setting WINELOADER to point to the original binary. Additionally, the locations
    # of the 32-bit and 64-bit binaries must differ only by the presence of "64" at the
    # end, due to the logic Wine uses to find the other binary (see get_alternate_loader
    # in dlls/kernel32/process.c). Therefore we do not use wrapProgram which would move
    # the binaries to ".wine-wrapped" and ".wine64-wrapped", but use makeWrapper directly,
    # and move the binaries to ".wine" and ".wine64".
    for i in wine wine64 ; do
      prog="$out/bin/$i"
      if [ -e "$prog" ]; then
        hidden="$(dirname "$prog")/.$(basename "$prog")"
        mv "$prog" "$hidden"
        makeWrapper "$hidden" "$prog" \
          --argv0 "" \
          --set WINELOADER "$hidden" \
          --prefix GST_PLUGIN_SYSTEM_PATH_1_0 ":" "$GST_PLUGIN_SYSTEM_PATH_1_0"
      fi
    done
  '';

  enableParallelBuilding = true;

  # https://bugs.winehq.org/show_bug.cgi?id=43530
  # https://github.com/NixOS/nixpkgs/issues/31989
  hardeningDisable = [ "bindnow" ]
    ++ lib.optional (stdenv.hostPlatform.isDarwin) "fortify"
    ++ lib.optional (supportFlags.mingwSupport) "format";

  passthru = {
    inherit pkgArches;
    tests = { inherit (nixosTests) wine; };
  };
  meta = {
    inherit version;
    homepage = "https://www.winehq.org/";
    license = with lib.licenses; [ lgpl21Plus ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode  # mono, gecko
    ];
    description = if supportFlags.waylandSupport then "An Open Source implementation of the Windows API on top of OpenGL and Unix (with experimental Wayland support)" else "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    platforms = if supportFlags.waylandSupport then (lib.remove "x86_64-darwin" prevPlatforms) else prevPlatforms;
    maintainers = with lib.maintainers; [ avnik raskin bendlas jmc-figueira ];
    inherit mainProgram;
  };
})

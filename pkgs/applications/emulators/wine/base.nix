{ stdenv, lib, pkgArches, makeSetupHook,
  pname, version, src, mingwGccs, monos, geckos, platforms,
  bison, flex, fontforge, makeWrapper, pkg-config,
  nixosTests,
  supportFlags,
  wineRelease,
  patches,
  moltenvk,
  buildScript ? null, configureFlags ? [], mainProgram ? "wine",
}:

with import ./util.nix { inherit lib; };

let
  prevName = pname;
  prevConfigFlags = configureFlags;

  setupHookDarwin = makeSetupHook {
    name = "darwin-mingw-hook";
    substitutions = {
      darwinSuffixSalt = stdenv.cc.suffixSalt;
      mingwGccsSuffixSalts = map (gcc: gcc.suffixSalt) mingwGccs;
    };
  } ./setup-hook-darwin.sh;

  # Using the 14.4 SDK allows Wine to use `os_sync_wait_on_address` for its futex implementation on Darwin.
  # It does an availability check, so older systems will still work.
  darwinFrameworks = lib.optionals stdenv.hostPlatform.isDarwin (toBuildInputs pkgArches (pkgs: [ pkgs.apple-sdk_14 ]));

  # Building Wine with these flags isn’t supported on Darwin. Using any of them will result in an evaluation failures
  # because they will put Darwin in `meta.badPlatforms`.
  darwinUnsupportedFlags = [
    "alsaSupport" "cairoSupport" "dbusSupport" "fontconfigSupport" "gtkSupport" "netapiSupport" "pulseaudioSupport"
    "udevSupport" "v4lSupport" "vaSupport" "waylandSupport" "x11Support" "xineramaSupport"
  ];

  badPlatforms = lib.optional (!supportFlags.mingwSupport || lib.any (flag: supportFlags.${flag}) darwinUnsupportedFlags) "x86_64-darwin";
in
stdenv.mkDerivation (finalAttrs:
lib.optionalAttrs (buildScript != null) { builder = buildScript; }
// lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    postBuild = ''
      # The Wine preloader must _not_ be linked to any system libraries, but `NIX_LDFLAGS` will link
      # to libintl, libiconv, and CoreFoundation no matter what. Delete the one that was built and
      # rebuild it with empty NIX_LDFLAGS.
      for preloader in wine-preloader wine64-preloader; do
        rm loader/$preloader &> /dev/null \
        && ( echo "Relinking loader/$preloader"; make loader/$preloader NIX_LDFLAGS="" NIX_LDFLAGS_${stdenv.cc.suffixSalt}="" ) \
        || echo "loader/$preloader not built, skipping relink."
      done
    '';
}
// {
  inherit version src;

  pname = prevName + lib.optionalString (wineRelease != "stable" && wineRelease != "unstable") "-${wineRelease}";

  # Fixes "Compiler cannot create executables" building wineWow with mingwSupport
  strictDeps = true;

  nativeBuildInputs = [
    bison
    flex
    fontforge
    makeWrapper
    pkg-config
  ]
  ++ lib.optionals supportFlags.mingwSupport (mingwGccs
    ++ lib.optional stdenv.hostPlatform.isDarwin setupHookDarwin);

  buildInputs = toBuildInputs pkgArches (with supportFlags; (pkgs:
  [ pkgs.freetype pkgs.perl pkgs.libunwind ]
  ++ lib.optional stdenv.hostPlatform.isLinux         pkgs.libcap
  ++ lib.optional stdenv.hostPlatform.isDarwin        pkgs.libinotify-kqueue
  ++ lib.optional cupsSupport            pkgs.cups
  ++ lib.optional gettextSupport         pkgs.gettext
  ++ lib.optional dbusSupport            pkgs.dbus
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
  ++ lib.optional fontconfigSupport      pkgs.fontconfig
  ++ lib.optional alsaSupport            pkgs.alsa-lib
  ++ lib.optional pulseaudioSupport      pkgs.libpulseaudio
  ++ lib.optional (xineramaSupport && x11Support) pkgs.xorg.libXinerama
  ++ lib.optional udevSupport            pkgs.udev
  ++ lib.optional vulkanSupport          (if stdenv.hostPlatform.isDarwin then moltenvk else pkgs.vulkan-loader)
  ++ lib.optional sdlSupport             pkgs.SDL2
  ++ lib.optional usbSupport             pkgs.libusb1
  ++ lib.optionals gstreamerSupport      (with pkgs.gst_all_1;
    [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav gst-plugins-bad ])
  ++ lib.optionals gtkSupport    [ pkgs.gtk3 pkgs.glib ]
  ++ lib.optionals openclSupport [ pkgs.opencl-headers pkgs.ocl-icd ]
  ++ lib.optionals tlsSupport    [ pkgs.openssl pkgs.gnutls ]
  ++ lib.optionals (openglSupport && !stdenv.hostPlatform.isDarwin) [ pkgs.libGLU pkgs.libGL pkgs.libdrm ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin darwinFrameworks
  ++ lib.optionals (x11Support) (with pkgs.xorg; [
    libX11 libXcomposite libXcursor libXext libXfixes libXi libXrandr libXrender libXxf86vm
  ])
  ++ lib.optionals waylandSupport (with pkgs; [
     wayland wayland-scanner libxkbcommon wayland-protocols wayland.dev libxkbcommon.dev
     libgbm
  ])));

  inherit patches;

  configureFlags = prevConfigFlags
    ++ lib.optionals supportFlags.waylandSupport [ "--with-wayland" ]
    ++ lib.optionals supportFlags.vulkanSupport [ "--with-vulkan" ]
    ++ lib.optionals ((stdenv.hostPlatform.isDarwin && !supportFlags.xineramaSupport) || !supportFlags.x11Support) [ "--without-x" ];

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = toString (map (path: "-rpath " + path) (
      map (x: "${lib.getLib x}/lib") ([ stdenv.cc.cc ]
        # Avoid adding rpath references to non-existent framework `lib` paths.
        ++ lib.subtractLists darwinFrameworks finalAttrs.buildInputs)
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
  hardeningDisable = [ "bindnow" "stackclashprotection" ]
    ++ lib.optional (stdenv.hostPlatform.isDarwin) "fortify"
    ++ lib.optional (supportFlags.mingwSupport) "format";

  passthru = {
    inherit pkgArches;
    inherit (src) updateScript;
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
    description = "Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    inherit badPlatforms platforms;
    maintainers = with lib.maintainers; [ avnik raskin bendlas jmc-figueira reckenrode ];
    inherit mainProgram;
  };
})

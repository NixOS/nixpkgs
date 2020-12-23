{ stdenv, fetchurl, mkDerivation, autoPatchelfHook, bash
, fetchFromGitHub, wrapGAppsHook, substituteAll, addOpenGLRunpath
# Dynamic libraries
, dbus_tools
, glib
, libglvnd
, qtbase
, qtdeclarative
, qtscript
, xorg
# Runtime
, coreutils, pciutils, procps, util-linux, iw, wirelesstools
, pulseaudioSupport ? true, libpulseaudio ? null
, alsaSupport ? stdenv.isLinux, alsaLib ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) concatStringsSep makeBinPath;

  version = "5.4.57450.1220";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "cphG/aTY56R82ME9NsDLDqiqThFnjWAxkpF1woDL4DM=";
    };
  };

  # Used for icons, appdata, and desktop file.
  desktopIntegration = fetchFromGitHub {
    owner = "flathub";
    repo = "us.zoom.Zoom";
    rev = "25e14f8141cdc682b4f7d9ebe15608619f5a19f2";
    sha256 = "0w3pdd5484r3nsb4iahi37jdlm37vm1053sb8k2zlqb9s554zjwp";
  };

in mkDerivation {
  pname = "zoom-us";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ autoPatchelfHook addOpenGLRunpath wrapGAppsHook ];
  # Let mkDerivation do it
  dontWrapGApps = true;

  buildInputs = [
    dbus_tools
    glib
    libglvnd
    qtbase
    qtdeclarative
    qtscript
    xorg.libX11
    xorg.libxcb
    xorg.libXext
    xorg.libXfixes
    xorg.libXtst
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
  ]
    ++ stdenv.lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ stdenv.lib.optionals alsaSupport [ alsaLib ]
  ;
  dontBuild = true;
  dontConfigure = true;

  installPhase =
    let
      files = concatStringsSep " " [
        "*.pcm"
        "ZoomLauncher"
        "ringtone"
        "sip"
        "timezones"
        "translations"
        "version.txt"
        "zoom"
        "zopen"
        "json"
        "getmem.sh"
        "getbssid.sh"
        "Embedded.properties"
      ];
    in ''
      runHook preInstall

      mkdir -p $out/{bin,share/zoom-us}

      cp -ar ${files} $out/share/zoom-us

      # It was evident that some webcams work only with upstream's libturbojpeg.so
      cp libturbojpeg.so $out/share/zoom-us/libturbojpeg.so
      mkdir -p $out/share/{applications,appdata,icons}

      # Desktop File
      cp ${desktopIntegration}/us.zoom.Zoom.desktop $out/share/applications
      substituteInPlace $out/share/applications/us.zoom.Zoom.desktop \
          --replace "Exec=zoom" "Exec=$out/bin/zoom-us"

      # Appdata
      cp ${desktopIntegration}/us.zoom.Zoom.appdata.xml $out/share/appdata

      # Icons
      for icon_size in 64 96 128 256; do
          path=$icon_size'x'$icon_size
          icon=${desktopIntegration}/us.zoom.Zoom.$icon_size.png

          mkdir -p $out/share/icons/hicolor/$path/apps
          cp $icon $out/share/icons/hicolor/$path/apps/us.zoom.Zoom.png
      done

      runHook postInstall
  '';

  # $out/share/zoom-us isn't in auto-wrap directories list, need manual wrapping
  dontWrapQtApps = true;

  qtWrapperArgs = [
    ''--prefix PATH : ${makeBinPath [ iw wirelesstools coreutils glib.dev pciutils procps util-linux ]}''
    # --run "cd ${placeholder "out"}/share/zoom-us"
    # ^^ unfortunately, breaks run arg into multiple array elements, due to
    # some bad array propagation. We'll do that in bash below
  ];

  preFixup = ''
    # Zoom expects "zopen" executable (needed for web login) to be present in CWD. Or does it expect
    # everybody runs Zoom only after cd to Zoom package directory? Anyway, :facepalm:
    qtWrapperArgs+=( --run "cd ${placeholder "out"}/share/zoom-us" )
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")

    for app in ZoomLauncher zopen zoom; do
      wrapQtApp $out/share/zoom-us/$app
    done

    ln -s $out/share/zoom-us/ZoomLauncher $out/bin/zoom-us
  '';

  postFixup = ''
    for app in ZoomLauncher zopen zoom; do
      addOpenGLRunpath $out/share/zoom-us/.$app-wrapped
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://zoom.us/";
    description = "zoom.us video conferencing application";
    license = stdenv.lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with stdenv.lib.maintainers; [ danbst tadfisher doronbehar ];
  };

}

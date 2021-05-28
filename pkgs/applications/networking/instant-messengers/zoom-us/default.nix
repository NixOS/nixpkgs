{ stdenv, fetchurl, mkDerivation, autoPatchelfHook, bash
, fetchFromGitHub
# Dynamic libraries
, dbus, glib, libGL, libX11, libXfixes, libuuid, libxcb, qtbase, qtdeclarative
, qtgraphicaleffects, qtimageformats, qtlocation, qtquickcontrols
, qtquickcontrols2, qtscript, qtsvg , qttools, qtwayland, qtwebchannel
, qtwebengine
# Runtime
, coreutils, faac, pciutils, procps, utillinux
, pulseaudioSupport ? true, libpulseaudio ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) concatStringsSep makeBinPath optional;

  version = "5.3.469451.0927";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "0qb9jx2zd5p6jk1g0xmh1f6xlf4gfl38ns6ixpc653qfimy8b0av";
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

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    dbus glib libGL libX11 libXfixes libuuid libxcb faac qtbase
    qtdeclarative qtgraphicaleffects qtlocation qtquickcontrols qtquickcontrols2
    qtscript qtwebchannel qtwebengine qtimageformats qtsvg qttools qtwayland
  ];

  runtimeDependencies = optional pulseaudioSupport libpulseaudio;

  installPhase =
    let
      files = concatStringsSep " " [
        "*.pcm"
        "*.png"
        "ZoomLauncher"
        "config-dump.sh"
        "timezones"
        "translations"
        "version.txt"
        "zcacert.pem"
        "zoom"
        "zoom.sh"
        "zopen"
      ];
    in ''
      runHook preInstall

      mkdir -p $out/{bin,share/zoom-us}

      cp -ar ${files} $out/share/zoom-us

      # TODO Patch this somehow; tries to dlopen './libturbojpeg.so' from cwd
      cp libturbojpeg.so $out/share/zoom-us/libturbojpeg.so

      # Again, requires faac with a nonstandard filename.
      ln -s $(readlink -e "${faac}/lib/libfaac.so") $out/share/zoom-us/libfaac1.so

      runHook postInstall
    '';

  postInstall = ''
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
  '';

  # $out/share/zoom-us isn't in auto-wrap directories list, need manual wrapping
  dontWrapQtApps = true;

  qtWrapperArgs = [
    ''--prefix PATH : ${makeBinPath [ coreutils glib.dev pciutils procps qttools.dev utillinux ]}''
    # --run "cd ${placeholder "out"}/share/zoom-us"
    # ^^ unfortunately, breaks run arg into multiple array elements, due to
    # some bad array propagation. We'll do that in bash below
  ];

  postFixup = ''
    # Zoom expects "zopen" executable (needed for web login) to be present in CWD. Or does it expect
    # everybody runs Zoom only after cd to Zoom package directory? Anyway, :facepalm:
    qtWrapperArgs+=( --run "cd ${placeholder "out"}/share/zoom-us" )

    for app in ZoomLauncher zopen zoom; do
      wrapQtApp $out/share/zoom-us/$app
    done

    ln -s $out/share/zoom-us/ZoomLauncher $out/bin/zoom-us
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

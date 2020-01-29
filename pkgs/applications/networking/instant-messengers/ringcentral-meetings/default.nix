{ stdenv, fetchurl, mkDerivation, autoPatchelfHook, bash
, dpkg
, fetchFromGitHub
# Dynamic libraries
, dbus, glib, libGL, libX11, libXfixes, libuuid, libxcb, qtbase, qtdeclarative
, qtimageformats, qtlocation, qtquickcontrols, qtquickcontrols2, qtscript, qtsvg
, qttools, qtwayland, qtwebchannel, qtwebengine
# Runtime
, coreutils, libjpeg_turbo, pciutils, procps, utillinux, libv4l
, pulseaudioSupport ? true, libpulseaudio ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) concatStringsSep makeBinPath optional;

  version = "19.3.286512.0827";
  srcs = {
    x86_64-linux = fetchurl {
      url = "http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsClientSetup.deb";
      sha256 = "d2abe77670263d1def0c98da3b1c949ca9f2b13cf477b0969a08ab843a0e6b88";
    };
  };

in mkDerivation {
  pname = "ringcentral-meetings";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  buildInputs = [
    dbus glib libGL libX11 libXfixes libuuid libxcb libjpeg_turbo
    qtbase qtdeclarative qtlocation qtquickcontrols qtquickcontrols2 qtscript
    qtwebchannel qtwebengine qtimageformats qtsvg qttools qtwayland
  ];

  runtimeDependencies = optional pulseaudioSupport libpulseaudio;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase =
    let
      files = concatStringsSep " " [
        "*.pcm"
        "*.png"
        "RingcentralLauncher"
        "config-dump.sh"
        "timezones"
        "translations"
        "version.txt"
        "zcacert.pem"
        "ringcentral"
        "ringcentral.sh"
        "ringcentrallinux"
        "zopen"
      ];
    in ''
      runHook preInstall

      mkdir -p $out/{bin,share/ringcentral-meetings}

      cd opt/ringcentral
      cp -ar ${files} $out/share/ringcentral-meetings

      # TODO Patch this somehow; tries to dlopen './libturbojpeg.so' from cwd
      ln -s $(readlink -e "${libjpeg_turbo.out}/lib/libturbojpeg.so") $out/share/ringcentral-meetings/libturbojpeg.so

      runHook postInstall
    '';

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}

    # Desktop File
    cd ../..
    cp usr/share/applications/Ringcentral.desktop $out/share/applications
    substituteInPlace $out/share/applications/Ringcentral.desktop \
        --replace "Exec=/usr/bin/ringcentral %U" "Exec=$out/bin/ringcentral-meetings %U"

    # Icon
    cp usr/share/pixmaps/Ringcentral.png $out/share/pixmaps
  '';

  # $out/share/ringcentral-meetings isn't in auto-wrap directories list, need manual wrapping
  dontWrapQtApps = true;

  qtWrapperArgs = [
    ''--prefix PATH : ${makeBinPath [ coreutils glib.dev pciutils procps qttools.dev utillinux ]}''
    ''--prefix LD_PRELOAD : ${libv4l}/lib/libv4l/v4l2convert.so''
    # --run "cd ${placeholder "out"}/share/ringcentral-meetings"
    # ^^ unfortunately, breaks run arg into multiple array elements, due to
    # some bad array propagation. We'll do that in bash below
  ];

  postFixup = ''
    # Ringcentral expects "zopen" executable (needed for web login) to be present in CWD. Or does it expect
    # everybody runs Ringcentral only after cd to Ringcentral package directory? Anyway, :facepalm:
    qtWrapperArgs+=( --run "cd ${placeholder "out"}/share/ringcentral-meetings" )

    for app in RingcentralLauncher zopen ringcentral; do
      wrapQtApp $out/share/ringcentral-meetings/$app
    done

    ln -s $out/share/ringcentral-meetings/RingcentralLauncher $out/bin/ringcentral-meetings
  '';

  meta = {
    homepage = "https://ringcentral.com/";
    description = "Ringcentral Meetings video conferencing application";
    license = stdenv.lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with stdenv.lib.maintainers; [ djmaze ];
  };

}

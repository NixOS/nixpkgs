{
  stdenv,
  lib,
  buildFHSEnv,
  writeShellScriptBin,
  fetchurl,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,
  socat,
  jq,
  kdePackages,
  ffmpeg,
  libmediainfo,
  libusb1,
  vapoursynth,
  xorg,
  systemdLibs,
  openssl,
  p7zip,
}:
let
  mpvForSVP = callPackage ./mpv.nix { };

  # Script provided by GitHub user @xrun1
  # https://github.com/xddxdd/nur-packages/issues/31#issuecomment-1812591688
  fakeLsof = writeShellScriptBin "lsof" ''
    for arg in "$@"; do
      if [ -S "$arg" ]; then
        printf %s p
        echo '{"command": ["get_property", "pid"]}' |
          ${socat}/bin/socat - "UNIX-CONNECT:$arg" |
          ${jq}/bin/jq -Mr .data
        printf '\n'
      fi
    done
  '';

  # SVP expects findmnt to return path to storage device for software protection.
  # Workaround for tmp-as-root and encrypted root use cases, by returning first storage device on system.
  fakeFindmnt = writeShellScriptBin "findmnt" ''
    find /dev/ -name 'nvme*n*p*' -or -name 'sd*' -or -name 'vd*' 2>/dev/null | sort | head -n1
  '';

  libraries = [
    mpvForSVP
    fakeLsof
    fakeFindmnt
    (lib.getLib stdenv.cc.cc)
    kdePackages.qtbase
    kdePackages.qtdeclarative
    ffmpeg.bin
    libmediainfo
    libusb1
    vapoursynth
    xorg.libX11
    systemdLibs
    openssl
  ];

  svp-dist = stdenv.mkDerivation (finalAttrs: {
    pname = "svp-dist";
    version = "4.7.305";
    src = fetchurl {
      url = "https://www.svp-team.com/files/svp4-linux.${finalAttrs.version}.tar.bz2";
      hash = "sha256-PWAcm/hIA4JH2QtJPP+gSJdJLRdfdbZXIVdWELazbxQ=";
    };

    nativeBuildInputs = [
      p7zip
    ];
    dontFixup = true;

    unpackPhase = ''
      tar xf ${finalAttrs.src}
    '';

    buildPhase = ''
      mkdir installer
      LANG=C grep --only-matching --byte-offset --binary --text  $'7z\xBC\xAF\x27\x1C' "svp4-linux.run" |
        cut -f1 -d: |
        while read ofs; do dd if="svp4-linux.run" bs=1M iflag=skip_bytes status=none skip=$ofs of="installer/bin-$ofs.7z"; done
    '';

    installPhase = ''
      mkdir -p $out/opt
      for f in "installer/"*.7z; do
        7z -bd -bb0 -y x -o"$out/opt/" "$f" || true
      done

      for SIZE in 32 48 64 128; do
        mkdir -p "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps"
        mv "$out/opt/svp-manager4-''${SIZE}.png" "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps/svp-manager4.png"
      done
      rm -f $out/opt/{add,remove}-menuitem.sh
    '';
  });

  fhs = buildFHSEnv {
    pname = "SVPManager";
    inherit (svp-dist) version;
    targetPkgs = pkgs: libraries;
    runScript = "${svp-dist}/opt/SVPManager";
    unshareUser = false;
    unshareIpc = false;
    unsharePid = false;
    unshareNet = false;
    unshareUts = false;
    unshareCgroup = false;
  };
in
stdenv.mkDerivation {
  pname = "svp";
  inherit (svp-dist) version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    mkdir -p $out/bin $out/share
    ln -s ${fhs}/bin/SVPManager $out/bin/SVPManager
    ln -s ${svp-dist}/share/icons $out/share/icons
  '';

  passthru.mpv = mpvForSVP;

  desktopItems = [
    (makeDesktopItem {
      name = "svp-manager4";
      exec = "${fhs}/bin/SVPManager %f";
      desktopName = "SVP 4 Linux";
      genericName = "Real time frame interpolation";
      icon = "svp-manager4";
      categories = [
        "AudioVideo"
        "Player"
        "Video"
      ];
      mimeTypes = [
        "video/x-msvideo"
        "video/x-matroska"
        "video/webm"
        "video/mpeg"
        "video/mp4"
      ];
      terminal = false;
      startupNotify = true;
    })
  ];

  meta = with lib; {
    mainProgram = "SVPManager";
    description = "SmoothVideo Project 4 (SVP4) converts any video to 60 fps (and even higher) and performs this in real time right in your favorite video player";
    homepage = "https://www.svp-team.com/wiki/SVP:Linux";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ xddxdd ];
  };
}

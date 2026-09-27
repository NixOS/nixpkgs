{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  xar,
  cpio,
  #curlWithGnuTls,
  #autoPatchelfHook,
}:

let
  version = "1.9.24";
  pname = "chataigne";

  platformInfo =
    {
      x86_64-linux = {
        arch = "linux-x64";
        ext = "AppImage";
        hash = "sha256-cxvdrFVBvFIVCUZyCpTb1IyrM0oRlE6mlwzi+k3Aiy4=";
      };
      aarch64-linux = {
        # compiled with QEMU -cpu max:cortex-a53
        # using cpuinfo https://github.com/pguyot/arm-runner-action/blob/main/cpuinfo/raspberrypi_zero2_w_arm64
        arch = "linux-aarch64";
        ext = "AppImage";
        hash = "sha256-x/70U6JmN/x502PuO0uTlI8HXw5kBKcw8IvnFCygS18=";
      };
      armv6l-linux = { # lib.systems.examples.raspberryPi
        # named armv8 on Chataigne's website
        # compiled with QEMU -cpu arm1176:cortex-a53
        # using cpuinfo https://github.com/pguyot/arm-runner-action/blob/main/cpuinfo/raspberrypi_zero_w
        arch = "linux-armhf";
        ext = "AppImage";
        hash = "sha256-VSSZnlKdHHg7h/QdF64Ggy06pIsWFpHq/Dz7g4QYHgQ=";
      };
      x86_64-darwin = {
        arch = "osx-intel";
        ext = "pkg";
        hash = "sha256-E7z7O/oI8KWXUEo4wV9awqolAW6tCuYzOfyGkGdul10=";
      };
      aarch64-darwin = {
        arch = "osx-silicon";
        ext = "pkg";
        hash = "sha256-KBEeNs3daAeomtGcvRyx0iX1uorsRUAj7abax/xF/H8=";
      };
      x86_64-windows = {
        arch = "win-x64";
        ext = "exe";
        hash = "sha256-FCFoZDlHZ6BgNycTOPx9cIEOVr9BQQwysDL+M6Dq78Y=";
      };
      # Windows 7 version also exists
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://benjamin.kuperberg.fr/chataigne/user/data/Chataigne-${platformInfo.arch}-${version}.${platformInfo.ext}";
    hash = platformInfo.hash;
  };

  meta = {
    description = "Artist-friendly Modular Machine for Art and Technology";
    homepage = "https://github.com/benkuper/Chataigne";
    downloadPage = "https://benjamin.kuperberg.fr/chataigne/en";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.axka ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-windows"
      "x86_64-windows7"
    ];
  };

  # .desktop and icons
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
if platformInfo.ext == "AppImage" then
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    # unshareIpc=false etc.?

    #nativeBuildInputs = [
    #  autoPatchelfHook
    #];

    passthru.updateScript = ./update.sh;

    #buildInputs = [
    #];
    extraPkgs = pkgs: with pkgs; [
      curlWithGnuTls
      bluez
      avahi
      libGL
    ];
    # TODO: read pkgs.code-cursor derivation

    /*
      extraInstallCommands = ''
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
      '';
    */
  }
else if platformInfo.ext == "pkg" then
  # macOS
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      makeWrapper
      xar
      cpio
    ];

    unpackPhase = ''
      xar -xf $src
      echo after xar
      ls -al # TODO: remove!!
      zcat < Chataigne.pkg/Payload | cpio -i
      echo after cpio
      ls -al # TODO: remove!!
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/Applications
      # TODO: not sure if this is right
      cp -R Chataigne.app $out/Applications/
    '';
  }
else if platformInfo.ext == "exe" then
  # Windows
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      install -D $src $out/bin/Chataigne.exe
    '';
  }
else
  throw "infallible"

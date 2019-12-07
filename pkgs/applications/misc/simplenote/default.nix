{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, makeDesktopItem
, makeWrapper
, stdenv
, udev
, wrapGAppsHook
}:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  pname = "simplenote";

  version = "1.11.0";

  sha256 = {
    x86_64-linux = "1ljam1yfiy1lh6lrknrq7cdqpj1q7f655mxjiiwv3izp98qr1f8s";
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      kiwi
    ];
    platforms = [
      "x86_64-linux"
    ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      url =
        "https://github.com/Automattic/simplenote-electron/releases/download/"
        + "v${version}/Simplenote-linux-${version}-amd64.deb";
      inherit sha256;
    };

    desktopItem = makeDesktopItem {
      categories = "Development";
      comment = "Simplenote for Linux";
      desktopName = "Simplenote";
      exec = "simplenote %U";
      icon = "simplenote";
      name = "simplenote";
      startupNotify = "true";
      type = "Application";
    };

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;
    dontWrapGApps = true;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook
    ];

    buildInputs = atomEnv.packages;

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
      mkdir -p "$out/bin"
      cp -R "opt" "$out"
      cp -R "usr/share" "$out/share"
      chmod -R g-w "$out"

      mkdir -p "$out/share/applications"
      cp "${desktopItem}/share/applications/"* "$out/share/applications"
    '';

    runtimeDependencies = [
      udev.lib
    ];

    postFixup = ''
      makeWrapper $out/opt/Simplenote/simplenote $out/bin/simplenote \
        "''${gappsWrapperArgs[@]}"
    '';
  };

in
linux

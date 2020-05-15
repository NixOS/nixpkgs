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

  version = "1.16.0";

  sha256 = {
    x86_64-linux = "01nk3dbyhs0p7f6b4bkrng95i29g0x7vxj0rx1qb7sm3n11yi091";
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
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] }" \
        "''${gappsWrapperArgs[@]}"
    '';
  };

in
linux

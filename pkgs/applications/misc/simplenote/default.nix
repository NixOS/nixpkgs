{ atomEnv, autoPatchelfHook, dpkg, fetchurl, makeDesktopItem, makeWrapper
, stdenv, udev, wrapGAppsHook }:

let
  inherit (stdenv.hostPlatform) system;

  pname = "simplenote";

  version = "1.8.0";

  sha256 = {
    x86_64-linux = "066gr1awdj5nwdr1z57mmvx7dd1z19g0wzsgbnrrb89bqfj67ykl";
  }.${system};

  meta = with stdenv.lib; {
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kiwi ];
    platforms = [ "x86_64-linux" ];
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
      name = "simplenote";
      comment = "Simplenote for Linux";
      exec = "simplenote %U";
      icon = "simplenote";
      type = "Application";
      startupNotify = "true";
      desktopName = "Simplenote";
      categories = "Development";
    };

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;
    dontWrapGApps = true;

    buildInputs = atomEnv.packages;

    nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook wrapGAppsHook ];

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
      mkdir -p "$out/bin"
      cp -R "opt" "$out"
      cp -R "usr/share" "$out/share"
      chmod -R g-w "$out"

      mkdir -p "$out/share/applications"
      cp "${desktopItem}/share/applications/"* "$out/share/applications"
    '';

    runtimeDependencies = [ udev.lib ];

    postFixup = ''
      ls -ahl $out
      makeWrapper $out/opt/Simplenote/simplenote $out/bin/simplenote \
      "''${gappsWrapperArgs[@]}"
    '';
  };

in
  linux

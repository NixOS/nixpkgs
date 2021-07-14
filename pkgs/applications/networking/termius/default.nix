{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, makeDesktopItem
, makeWrapper
, stdenv
, lib
, udev
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "termius";
  version = "7.16.0";

  src = fetchurl {
    # find the latest version by
    # curl https://deb.termius.com/dists/squeeze/main/binary-amd64/Packages
    url = "https://deb.termius.com/pool/main/t/termius-app/termius-app_${version}_amd64.deb";
    sha256 = "013nli61bk4x4hkhr6gcpzm1y8ycmqk3vr7q0w2dn2bfdwjg559v";
  };

  desktopItem = makeDesktopItem {
    categories = "Network;";
    comment = "The SSH client that works on Desktop and Mobile";
    desktopName = "Termius";
    exec = "termius-app";
    genericName = "Cross-platform SSH client";
    icon = "termius-app";
    name = "termius-app";
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper wrapGAppsHook ];

  buildInputs = atomEnv.packages;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"
    # Desktop file
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"

    runHook postInstall
  '';

  runtimeDependencies = [ (lib.getLib udev) ];

  postFixup = ''
    makeWrapper $out/opt/Termius/termius-app $out/bin/termius-app \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "A cross-platform SSH client with cloud data sync and more";
    homepage = "https://termius.com/";
    downloadPage = "https://termius.com/linux/";
    license = licenses.unfree;
    maintainers = with maintainers; [ Br1ght0ne th0rgal ];
    platforms = [ "x86_64-linux" ];
  };
}

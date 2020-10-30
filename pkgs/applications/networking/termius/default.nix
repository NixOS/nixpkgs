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
  version = "6.4.1";

  src = fetchurl {
    url = "https://deb.termius.com/pool/main/t/termius-app/termius-app_${version}_amd64.deb";
    sha256 = "0vc4nz5yndg11zhs92xj496jqzlhy9g0vqlfqrmg8zpf9ciygbqz";
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
    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    # Desktop file
    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  runtimeDependencies = [ (lib.getLib udev) ];

  postFixup = ''
    makeWrapper $out/opt/Termius/termius-app $out/bin/termius-app \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with stdenv.lib; {
    description = "A cross-platform SSH client with cloud data sync and more";
    homepage = "https://termius.com/";
    downloadPage = "https://termius.com/linux/";
    license = licenses.unfree;
    maintainers = with maintainers; [ filalex77 ];
    platforms = [ "x86_64-linux" ];
  };
}

{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  wrapGAppsHook3,
  libayatana-appindicator,
  libayatana-indicator,
  libdbusmenu,
  ayatana-ido,
  zenity,
}:
stdenv.mkDerivation rec {
  pname = "gopeed";
  version = "1.6.5";

  src = fetchurl {
    url = "https://github.com/GopeedLab/gopeed/releases/download/v${version}/Gopeed-v${version}-linux-amd64.deb";
    hash = "sha256-pFxFw8ZNV8u0Wbeh5/j/EpuH9GiyjFVyLl2M7jUr7tc=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    libayatana-appindicator
    libayatana-indicator
    libdbusmenu
    ayatana-ido
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r opt $out/app
    cp -r usr/share $out/share

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapper $out/app/gopeed/gopeed $out/bin/gopeed \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ zenity ]}
  '';

  meta = {
    homepage = "https://gopeed.com";
    description = "Modern download manager that supports all platforms. Built with Golang and Flutter";
    mainProgram = "gopeed";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
  };
}

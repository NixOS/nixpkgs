{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "quickgui";
  version = "1.2.8";

  src = fetchurl {
    url = "https://github.com/quickemu-project/quickgui/releases/download/v${version}/quickgui_${version}-1_lunar1.0_amd64.deb";
    sha256 = "sha256-crnV7OWH5UbkMM/TxTIOlXmvqBgjFmQG7RxameMOjH0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    wrapGAppsHook
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    runHook preInstall

    mv usr $out
    substituteInPlace $out/share/applications/quickgui.desktop \
      --replace "/usr" $out

    runHook postInstall
  '';

  meta = {
    description = "A Flutter frontend for quickemu";
    homepage = "https://github.com/quickemu-project/quickgui";
    changelog = "https://github.com/quickemu-project/quickgui/releases/tag/v${version}";
    maintainers = [ lib.maintainers.heyimnova ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "quickgui";
  };
}

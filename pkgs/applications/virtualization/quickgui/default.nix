{ stdenvNoCC
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook3
, quickemu
, gnome
}:

stdenvNoCC.mkDerivation rec {
  pname = "quickgui";
  version = "1.2.8";

  src = fetchurl {
    url = "https://github.com/quickemu-project/quickgui/releases/download/v${version}/quickgui_${version}-1_lunar1.0_amd64.deb";
    sha256 = "sha256-crnV7OWH5UbkMM/TxTIOlXmvqBgjFmQG7RxameMOjH0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    quickemu
    gnome.zenity
  ];

  strictDeps = true;

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    runHook preInstall

    mv usr $out

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ quickemu gnome.zenity ]}
    )
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/quickgui.desktop \
      --replace "/usr" $out

    # quickgui PR 88
    echo "Categories=System;" >> $out/share/applications/quickgui.desktop
  '';

  meta = with lib; {
    description = "Flutter frontend for quickemu";
    homepage = "https://github.com/quickemu-project/quickgui";
    changelog = "https://github.com/quickemu-project/quickgui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ heyimnova ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "quickgui";
  };
}

{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "jackbox-utility";
  version = "1.3.7+1";

  src = fetchurl {
    url = "https://github.com/JackboxUtility/JackboxUtility/releases/download/${version}/JackboxUtility_Linux.zip";
    hash = "sha256-fPLcbVqZ5rXkYRmBsOacwuJaIK47/JZMqsJRQTTsZRM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications
    unzip -d $out/bin $src
    mv $out/bin/JackboxUtility $out/bin/${pname}
    chmod +x $out/bin/${pname}

    runHook postInstall
  '';

  postInstall = ''
    cat << EOF > $out/share/applications/${pname}.desktop
      [Desktop Entry]
      Version=${version}
      Type=Application
      Name=JackboxUtility
      Exec=$out/bin/${pname}
      Icon=$out/bin/data/flutter_assets/assets/logo.png
      Terminal=false
      Comment=An app to download patches and launch Jackbox games
    EOF
    chmod +x $out/share/applications/${pname}.desktop
  '';

  meta = with lib; {
    description = "An app to download patches and launch Jackbox games ";
    homepage = "https://github.com/JackboxUtility/JackboxUtility";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jpeterburs ];
    mainProgram = "jackbox-utility";
  };
}

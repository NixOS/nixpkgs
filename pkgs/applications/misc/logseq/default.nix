{ lib
, stdenv
, fetchurl
, appimageTools
, appimage-run
, makeWrapper
, git
}:

stdenv.mkDerivation rec {
  pname = "logseq";
  version = "0.8.17";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
    hash = "sha256-z7v59wXvSIDC7f4IMT8bblPgn+3+J54XqIPzXqWDses=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extract {
    inherit pname src version;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/${pname}/resources/app/icons
    cp -a ${appimageContents}/resources/app/icons/logseq.png $out/share/${pname}/resources/app/icons/logseq.png
    cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop

    # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
    makeWrapper ${appimage-run}/bin/appimage-run $out/bin/logseq \
      --set "LOCAL_GIT_DIRECTORY" ${git} \
      --add-flags ${src}

    # Make the desktop entry run the app using appimage-run
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace Exec=Logseq "Exec=$out/bin/logseq" \
      --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ weihua ];
    platforms = [ "x86_64-linux" ];
  };
}

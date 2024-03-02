{ lib
, appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  pname = "tutanota-desktop";
  version = "3.122.5";

  src = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/tutanota-desktop-linux.AppImage";
    hash = "sha256-3M53Re6FbxEXHBl5KBLDjZg0uTIv8JIT0DlawNRPXBc=";
  };

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

  extraInstallCommands =
    let appimageContents = appimageTools.extract { inherit pname version src; };
    in ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -Dm 444 ${appimageContents}/tutanota-desktop.desktop -t $out/share/applications
      install -Dm 444 ${appimageContents}/tutanota-desktop.png -t $out/share/pixmaps

      substituteInPlace $out/share/applications/tutanota-desktop.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "Tuta official desktop client";
    homepage = "https://tuta.com/";
    changelog = "https://github.com/tutao/tutanota/releases/tag/tutanota-desktop-release-${version}";
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "tutanota-desktop";
    platforms = [ "x86_64-linux" ];
  };
}

{ appimageTools, lib, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "cider";
  version = "1.5.7";

  src = fetchurl {
    url = "https://github.com/ciderapp/cider-releases/releases/download/v${version}/Cider-${version}.AppImage";
    sha256 = "sha256-fWpt7YxqEDa1U4CwyVZwgbiwe0lrh64v0cJG9pbNMUU=";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "A new look into listening and enjoying Apple Music in style and performance.";
    homepage = "https://github.com/ciderapp/Cider";
    license = licenses.agpl3;
    maintainers = [ maintainers.cigrainger ];
    platforms = [ "x86_64-linux" ];
  };
}

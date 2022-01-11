{ appimageTools, lib, fetchurl }:
let
  pname = "apple-music-electron";
  version = "1.5.5";
  name = "Apple.Music-${version}";

  src = fetchurl {
    url = "https://github.com/cryptofyre/Apple-Music-Electron/releases/download/v${version}/${name}.AppImage";
    sha256 = "1gb6j3nvam9fcpsgiv56jccg9a4y14vzsyw11h3hckaigy90knpx";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Unofficial Apple Music application without having to bother with a Web Browser or iTunes";
    homepage = "https://github.com/iiFir3z/Apple-Music-Electron";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
}

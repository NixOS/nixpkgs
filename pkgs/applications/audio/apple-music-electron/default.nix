{ appimageTools, lib, fetchurl }:
let
  pname = "apple-music-electron";
  version = "1.5.2";
  name = "Apple.Music-${version}";

  src = fetchurl {
    url = "https://github.com/iiFir3z/Apple-Music-Electron/releases/download/${version}/${name}.AppImage";
    sha256 = "1jl0wgwy6ajmfkzygwb7cm9m49nkhp3x6vd8kwmh6ccs3jy4ayp5";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=$out/bin/apple-music-electron'
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

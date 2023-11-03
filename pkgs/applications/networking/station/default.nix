{ appimageTools, fetchurl, lib }:
let
  pname = "station";
  version = "v2.5.0";
  arch = "x86_64";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/getstation/desktop-app-releases/releases/download/${version}/Station-${arch}.AppImage";
    sha256 = "72fdb91171712078596faada28135d2ead6cad63780596085d0f5c1b32ee4c1c";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiArch = false;
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/browserx.desktop $out/share/applications/browserx.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/browserx.png \
      $out/share/icons/hicolor/512x512/apps/browserx.png
    substituteInPlace $out/share/applications/browserx.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A single place for all of your web applications";
    homepage = "https://getstation.com";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}

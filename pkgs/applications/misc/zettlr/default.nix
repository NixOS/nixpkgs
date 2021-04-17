{ appimageTools
, lib
, fetchurl
, gtk3
, gsettings-desktop-schemas
, texlive
, pandoc
}:

# Based on https://gist.github.com/msteen/96cb7df66a359b827497c5269ccbbf94 and joplin-desktop nixpkgs.
let
  pname = "zettlr";
  version = "1.8.7";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/Zettlr/Zettlr/releases/download/v${version}/Zettlr-${version}-x86_64.appimage";
    sha256 = "0zbmlk5qk92b3zycs0bmdwgc8fn4a4dv1yvq9q8q2wxz4ammx6c0";
  };
  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ texlive pandoc ];
  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/Zettlr.desktop $out/share/applications/zettlr.desktop
    install -m 444 -D ${appimageContents}/Zettlr.png $out/share/icons/hicolor/512x512/apps/zettlr.png
    substituteInPlace $out/share/applications/zettlr.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A markdown editor for writing academic texts and taking notes";
    homepage = "https://www.zettlr.com";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ tfmoraes ];
  };
}

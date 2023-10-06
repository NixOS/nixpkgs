{ appimageTools, fetchurl, lib, makeDesktopItem }:

let
  pname = "tusk";
  version = "0.23.0";

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/klaussinani/tusk/v${version}/static/Icon.png";
    sha256 = "1jqclyrjgg6hir45spg75plfmd8k9nrsrzw3plbcg43s5m1qzihb";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = icon;
    desktopName = pname;
    genericName = "Evernote desktop app";
    categories = [ "Application" ];
  };

in appimageTools.wrapType2 rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/klaussinani/tusk/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "02q7wsnhlyq8z74avflrm7805ny8fzlmsmz4bmafp4b4pghjh5ky";
  };


  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiArch = false; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  meta = with lib; {
    description = "Refined Evernote desktop app";
    longDescription = ''
      Tusk is an unofficial, featureful, open source, community-driven, free Evernote app used by people in more than 140 countries. Tusk is indicated by Evernote as an alternative client for Linux environments trusted by the open source community.
    '';
    homepage = "https://klaussinani.github.io/tusk/";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
    platforms = [ "x86_64-linux" ];
  };
}

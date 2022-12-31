{ lib, stdenv, appimageTools, fetchurl }:

let
  pname = "clickup";
  name = "clickup-desktop";
  version = "2.0.23";

  plat = {
    i386-linux = "i386";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    i386-linux = "";
    x86_64-linux = "JzTwbDekTWNPUCyYnUHgiXo7PQG/MGl1EiIlJbTaqXI=";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/clickup/clickup-release/releases/download/v${version}/${name}-${version}-${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };
in
  appimageTools.wrapType2 rec {
    inherit name src;
    
    extraInstallCommands = ''
        # ls ${appimageContents}
        install -m 444 -D ${appimageContents}/${name}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${name}.desktop \
          --replace 'Exec=AppRun' 'Exec=${name}'
        cp -r ${appimageContents}/usr/share/icons $out/share
      '';

    meta = with lib; {
      description = "An all-in-one project management platform";
      longDescription = "ClickUp is an all-in-one project management platform that eliminates the need of using more than one tool for your organization’s workflow. Its features include Kanban boards, recurring tasks, task time tracking, MarkDown support, Gantt charts, Scrum boards, calendar management etc.";
      homepage = "https://clickup.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [ totoroot ];
      platforms = [ "x86_64-linux" "i386-linux" ];
    };
}

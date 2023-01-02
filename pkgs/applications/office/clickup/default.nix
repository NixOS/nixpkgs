{ lib, stdenv, fetchurl, appimageTools, makeWrapper, undmg, unzip }:

let
  pname = "clickup";
  name = "ClickUp";
  version = "3.1.2";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  src = fetchurl {
    url = {
      x86_64-linux = "https://desktop.clickup.com/linux/${name}-{version}.AppImage";
      x86_64-darwin = "https://desktop.clickup.com/mac/dmg/x64/${name}%20${version}-x64.dmg";
      aarch64-darwin = "https://desktop.clickup.com/mac/dmg/arm64/${name}%20${version}-arm64.dmg";
    }.${system} or throwSystem;

    sha256 = {
      x86_64-linux = "0rk382mbzraqd3gisqbdprl9i1fsf2vrqhagwkczpagxab9yqjs2";
      x86_64-darwin = "11lvysh36431ryipkip193rlr4id8fas48x304s82kj1g4ipz7n9";
      aarch64-darwin = "1b2adpcin428420bq917334ak2j76l98sdv71vh7jx5x8gc7lyv6";
    }.${system} or throwSystem;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  meta = with lib; {
    description = "An all-in-one project management platform";
    longDescription = ''ClickUp is an all-in-one project management platform that eliminates the need of using
      more than one tool for your organization’s workflow. Its features include Kanban boards, recurring tasks,
      task time tracking, MarkDown support, Gantt charts, Scrum boards, calendar management etc.
    '';
    homepage = "https://clickup.com/";
    downloadPage = "https://clickup.com/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ totoroot ];
  };

  linux = appimageTools.wrapType2 {
    inherit pname version src;
    meta = meta // { platforms = [ "x86_64-linux" ]; };
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${name}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src;
    meta = meta // { platforms = [ "x86_64-darwin" "aarch64-darwin" ]; };
    sourceRoot = "${name}.app";
    nativeBuildInputs = [
      makeWrapper
      undmg
      unzip
    ];
    installPhase = ''
      mkdir -p $out/{Applications/${name}.app,bin}
      cp -R . $out/Applications/${name}.app
      makeWrapper $out/Applications/${name}.app/Contents/MacOS/${name} $out/bin/${pname}
    '';
  };
in
  if stdenv.isDarwin then darwin else linux

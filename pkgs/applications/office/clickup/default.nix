{ lib, stdenv, fetchurl, appimageTools, makeWrapper, undmg, unzip }:

let
  inherit (stdenv.hostPlatform) system;
  pname = "clickup";
  name = "clickup-desktop";
  appname = "ClickUp";
  version = "2.0.23";

  platform = {
    i386-linux = "i386";
    x86_64-linux = "x86_64";
    x86_64-darwin = "mac";
  }.${stdenv.hostPlatform.system};

  extension = {
    i386-linux = "AppImage";
    x86_64-linux = "AppImage";
    x86_64-darwin = "dmg";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    i386-linux = "16r9qia1ryyziiglvfkx38g6y7s582sx0hv2sa9wkq0w331zyf82";
    x86_64-linux = "0wm9vas2a99229snjc5z04yknyl9w10rv61ca17n6kd46xng0d17";
    x86_64-darwin = "0dwn3b77vh7yq25xdhbffalqdxh8nqg875cn4v5pc4mf1khqd0nm";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/clickup/clickup-release/releases/download/v${version}/${name}-${version}-${platform}.${extension}";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  meta = with lib; {
    description = "An all-in-one project management platform";
    longDescription = "ClickUp is an all-in-one project management platform that eliminates the need of using more than one tool for your organization’s workflow. Its features include Kanban boards, recurring tasks, task time tracking, MarkDown support, Gantt charts, Scrum boards, calendar management etc.";
    homepage = "https://clickup.com/";
    downloadPage = "https://github.com/clickup/clickup-release/releases";
    license = licenses.unfree;
    maintainers = with maintainers; [ totoroot ];
  };

  linux = appimageTools.wrapType2 {
    inherit pname version src;
    meta = meta // { platforms = [ "x86_64-linux" "aarch64-linux" ]; };
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${name}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${name}.desktop \
        --replace 'Exec=AppRun' 'Exec=${name}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname appname version src;
    meta = meta // { platforms = [ "x86_64-darwin" ]; };
    sourceRoot = "${appname}.app";
    nativeBuildInputs = [ makeWrapper undmg unzip ];
    installPhase = ''
      mkdir -p $out/{Applications/${appname}.app,bin}
      cp -R . $out/Applications/${appname}.app
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
    '';
  };
in
  if stdenv.isDarwin then darwin else linux

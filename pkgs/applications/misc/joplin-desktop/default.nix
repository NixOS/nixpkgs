{ lib, stdenv, appimageTools, fetchurl, makeWrapper, undmg }:

let
  pname = "joplin-desktop";
  version = "2.10.4";
  name = "${pname}-${version}";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  suffix = {
    x86_64-linux = "AppImage";
    x86_64-darwin = "dmg";
  }.${system} or throwSystem;

  src = fetchurl {
    url = "https://github.com/laurent22/joplin/releases/download/v${version}/Joplin-${version}.${suffix}";
    sha256 = {
      x86_64-linux = "sha256-KEEPPtWxaY6+Nu/CE+AVAnaVZ30zmASWiIYaJt4a+3E=";
      x86_64-darwin = "sha256-8Rkj1pV6tJygznbfELnAhzhh7ImnTm9dxCxCjYlWdnU=";
    }.${system} or throwSystem;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

  meta = with lib; {
    description = "An open source note taking and to-do application with synchronisation capabilities";
    longDescription = ''
      Joplin is a free, open source note taking and to-do application, which can
      handle a large number of notes organised into notebooks. The notes are
      searchable, can be copied, tagged and modified either from the
      applications directly or from your own text editor. The notes are in
      Markdown format.
    '';
    homepage = "https://joplinapp.org";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  linux = appimageTools.wrapType2 rec {
    inherit name src meta;

    profile = ''
      export LC_ALL=C.UTF-8
    '';

    multiPkgs = null; # no 32bit needed
    extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
    extraInstallCommands = ''
      mv $out/bin/{${name},${pname}}
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
      install -Dm444 ${appimageContents}/@joplinapp-desktop.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/@joplinapp-desktop.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/@joplinapp-desktop.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}' \
        --replace 'Icon=joplin' "Icon=@joplinapp-desktop"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit name src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Joplin.app";

    installPhase = ''
      mkdir -p $out/Applications/Joplin.app
      cp -R . $out/Applications/Joplin.app
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux

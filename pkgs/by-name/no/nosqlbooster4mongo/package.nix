{
  appimageTools,
  lib,
  fetchurl,
  jdk21,
  stdenv,
  _7zz
}:
let
  pname = "nosqlbooster4mongo";
  version = "8.1.7";
  src = fetchurl {
    url = "https://s3.nosqlbooster.com/download/releasesv8/nosqlbooster4mongo-${version}.AppImage";
    hash = "sha256-+LJS3lqRPAIcCbGniLcxoL1yfRhlmn7S1OrWuedHufU=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [
    # Required to run DynamoDB locally
    pkgs.xorg.libXtst
    pkgs.libnotify
    pkgs.gnome2.GConf
  ];

  extraInstallCommands = let
    appimageContents = appimageTools.extract {
      inherit pname version src;
    };
  in ''
    mkdir -p $out/share/applications $out/share/pixmaps
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    # Install XDG Desktop file and its icon
    install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps

    # Replace wrong exec statement in XDG Desktop file
    substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
  '';

  meta = {
    description = "Shell-centric GUI tool for MongoDB";
    homepage = "https://nosqlbooster.com/home";
    changelog = "https://nosqlbooster.com/blog/announcing-nosqlbooster-81/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ lynxeko ];
    platforms = [ "x86_64-linux" ];
  };
}

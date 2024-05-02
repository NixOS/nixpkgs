{ lib, stdenv, fetchurl, fetchzip, appimageTools, undmg }:
let
  pname = "git-butler";
  version = "0.11.7";

  build_version = "889";

  src = {
    x86_64-darwin = fetchurl {
      urls = let
        base_url =
          "https://releases.gitbutler.com/releases/release/${version}-${build_version}/macos/x86_64/GitButler_${version}_x64.dmg";
      in [ base_url "https://web.archive.org/web/20240522095316/${base_url}" ];
      hash = "sha256-5mpcrwZ+BogmbEE/jAlOFvo5KA58IGV/peQFxveY9o8=";
    };
    aarch64-darwin = fetchurl {
      urls = let
        base_url =
          "https://releases.gitbutler.com/releases/release/${version}-${build_version}/macos/aarch64/GitButler_${version}_aarch64.dmg";
      in [ base_url "https://web.archive.org/web/20240522102156/${base_url}" ];
      hash = "sha256-uej3EEbG21EKdjRHJE9cgvRrU3dZclf9KQt7L6Ggz0U=";
    };
    x86_64-linux = fetchzip {
      urls = let
        base_url =
          "https://releases.gitbutler.com/releases/release/${version}-${build_version}/linux/x86_64/git-butler_${version}_amd64.AppImage.tar.gz";
      in [ base_url "https://web.archive.org/web/20240522102215/${base_url}" ];
      hash = "sha256-XuqyhaE1gi04m7F1V/Ca82aUpL8H8H6fnnPTiEX9oBY=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  meta = {
    description =
      "A Git client for simultaneous branches on top of your existing workflow.";
    mainProgram = "git-butler";
    homepage = "https://gitbutler.com/";
    changelog =
      "https://discord.com/channels/1060193121130000425/1183737922785116161";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
in if stdenv.isDarwin then
  stdenv.mkDerivation {
    inherit pname version src meta;

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      mv Gitbutler.app $out/Applications/

      runHook postInstall
    '';
  }
else
  let appImageFile = "${src}/git-butler_${version}_amd64.AppImage";
  in appimageTools.wrapType2 {
    inherit pname version meta;
    src = appImageFile;

    extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

    extraInstallCommands = let
      appimageContents = appimageTools.extractType2 {
        inherit pname version;
        src = appImageFile;
      };
    in ''
      # Install .desktop files
      install -Dm444 ${appimageContents}/git-butler.desktop -t $out/share/applications
      install -Dm444 ${appimageContents}/git-butler.png -t $out/share/pixmaps
    '';
  }

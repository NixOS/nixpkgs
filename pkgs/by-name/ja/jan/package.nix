{
  lib,
  appimageTools,
  fetchurl,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  stdenv,
  fetchzip,
  makeWrapper,
}:

let
  pname = "Jan";
  version = "0.8.2";

  darwin-src = fetchzip {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan-mac-universal-${version}.zip";
    hash = "sha256-DUyPMsy9POcxY5OyQu1IBAijTbUZACQB87j0CQDrw8A=";
  };

  linux-src = fetchurl {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
    hash = "sha256-OWg8P4g2g+LVJU+SnjajG2cqWnzl5X2fjqTGkIC3kAY=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version;
    src = linux-src;
  };

  meta = {
    changelog = "https://github.com/janhq/jan/releases/tag/v${version}";
    description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
    homepage = "https://github.com/janhq/jan";
    license = lib.licenses.asl20;
    mainProgram = "Jan";
    maintainers = with lib.maintainers; [ dfjay ];
    platforms =
      lib.platforms.darwin
      ++ (with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64);
  };

  linux = appimageTools.wrapType2 {
    inherit pname version;
    src = linux-src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    extraPkgs =
      pkgs:
      lib.optionals cudaSupport [
        cudaPackages.cudatoolkit
      ];

    inherit meta;
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      meta
      ;

    src = darwin-src;

    dontUnpack = true;

    sourceRoot = "${pname}.app";
    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/${pname}.app
      mkdir -p $out/bin
      cp -R $src/. $out/Applications/${pname}.app/
      if [ -x "$out/Applications/${pname}.app/Contents/MacOS/${pname}" ]; then
        makeWrapper "$out/Applications/${pname}.app/Contents/MacOS/${pname}" $out/bin/${pname}
      fi

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux

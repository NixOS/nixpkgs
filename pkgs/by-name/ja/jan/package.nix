{
  lib,
  appimageTools,
  fetchurl,
<<<<<<< HEAD
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  stdenv,
  fetchzip,
  makeWrapper,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  pname = "Jan";
<<<<<<< HEAD
  version = "0.7.5";

  darwin-src = fetchzip {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan-mac-universal-${version}.zip";
    hash = "sha256-stTsLKE+2gUKAVwJ2/gOckoL6Nygwr0rkugD1jGj1w4=";
  };

  linux-src = fetchurl {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
    hash = "sha256-RIEBpeogNIDPMpoY5Gk8q4+t7jxcWJEZLPqJHWyaVk4=";
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
    maintainers = [ ];
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
=======
  version = "0.6.10";
  src = fetchurl {
    url = "https://github.com/menloresearch/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
    hash = "sha256-eag8c/Jp2ahV71kEuFoT2rmz0S9RPbiqy5YBO0Z+ICY=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    changelog = "https://github.com/menloresearch/jan/releases/tag/v${version}";
    description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
    homepage = "https://github.com/menloresearch/jan";
    license = lib.licenses.agpl3Plus;
    mainProgram = "Jan";
    maintainers = [ ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

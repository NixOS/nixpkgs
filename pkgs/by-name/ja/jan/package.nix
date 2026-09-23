{
  lib,
  appimageTools,
  fetchurl,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
}:

let
  version = "0.8.4";

  darwin-src = fetchzip {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan-mac-universal-${version}.zip";
    hash = "sha256-hK9cu9c2kJRCJ3iy0CucRP0whgDgF5K29JgR4AIKXVg=";
  };

  linux-src = fetchurl {
    url = "https://github.com/janhq/jan/releases/download/v${version}/Jan_${version}_amd64.AppImage";
    hash = "sha256-NNTIq02kisIjINS2TCh0Rb2UyRMSlJLR2+uzZmWxSVo=";
  };

  appimageContents = appimageTools.extract {
    pname = "Jan";
    inherit version;
    src = linux-src;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/janhq/jan/releases/tag/v${version}";
    description = "Open source alternative to ChatGPT that runs 100% offline on your computer";
    homepage = "https://github.com/janhq/jan";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "Jan";
    maintainers = with lib.maintainers; [ dfjay ];
    platforms =
      lib.platforms.darwin
      ++ (with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64);
  };

  linux = appimageTools.wrapType2 {
    pname = "Jan";
    inherit version;
    src = linux-src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    extraPkgs = pkgs: lib.optionals cudaSupport [ cudaPackages.cuda_cudart ];

    inherit passthru meta;
  };

  darwin = stdenvNoCC.mkDerivation {
    pname = "Jan";
    inherit version;

    strictDeps = true;
    __structuredAttrs = true;

    src = darwin-src;

    nativeBuildInputs = [
      makeWrapper
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/Jan.app
      mkdir -p $out/bin
      cp -R $src/. $out/Applications/Jan.app/
      if [ -x "$out/Applications/Jan.app/Contents/MacOS/Jan" ]; then
        makeWrapper "$out/Applications/Jan.app/Contents/MacOS/Jan" $out/bin/Jan
      fi

      runHook postInstall
    '';

    inherit passthru meta;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux

{
  lib,
  appimageTools,
  fetchurl,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
}:

let
  version = "0.8.6";

  darwin-src = fetchzip {
    url = "https://github.com/janhq/jan/releases/download/v${version}/jan-mac-universal-${version}.zip";
    hash = "sha256-jQIY69PT+jMh3bUd2tgscKzvT/TBy8TqF6pFrsl7XAg=";
  };

  linux-src = fetchurl {
    url = "https://github.com/janhq/jan/releases/download/v${version}/Jan_${version}_amd64.AppImage";
    hash = "sha256-L+cPsIhHOnvbSZ5c4HHVpXPFR1VpFIJduYnsHdEFIGY=";
  };

  appimageContents = appimageTools.extract {
    pname = "jan";
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
    mainProgram = "Jan-Desktop";
    maintainers = with lib.maintainers; [ dfjay ];
    platforms =
      lib.platforms.darwin
      ++ (with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64);
  };

  linux = appimageTools.wrapType2 {
    pname = "jan";
    inherit version;
    src = linux-src;

    executableName = "Jan-Desktop";

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    inherit passthru meta;
  };

  darwin = stdenvNoCC.mkDerivation {
    pname = "jan";
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
      makeWrapper "$out/Applications/Jan.app/Contents/MacOS/Jan-Desktop" $out/bin/Jan-Desktop

      runHook postInstall
    '';

    inherit passthru meta;
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux

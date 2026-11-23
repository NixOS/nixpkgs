{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "hamrs-pro";
  version = "2.53.0";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-linux-x86_64.AppImage";
      hash = "sha256-Ne9cU0yeCUZ4EylIjVceAQsM5TXEMXxiZ6y9WsblLmI=";
    };

    aarch64-linux = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-linux-arm64.AppImage";
      hash = "sha256-RrUslg13H7hJJ9/XHhD13t7ohgmKmonaDe4Jn8DpSZ4=";
    };
    aarch64-darwin = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-mac-arm64.dmg";
      hash = "sha256-EivhY8gazHFXsva2I49t/tN76fm+WoMI1/H7UoWl+cg=";
    };
  };

  src = srcs.${stdenvNoCC.hostPlatform.system} or throwSystem;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://hamrs.app/";
    description = "Simple, portable logger tailored for activities like Parks on the Air, Field Day, and more";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      ethancedwards8
      jhollowe
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    extraInstallCommands = ''
      install -m 444 -D ${finalAttrs.contents}/hamrs-pro.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/hamrs-pro.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=hamrs-pro'
      cp -r ${finalAttrs.contents}/usr/share/icons $out/share
    '';
  });

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [ _7zz ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  };
in
if stdenvNoCC.hostPlatform.isDarwin then darwin else linux

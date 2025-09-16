{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  _7zz,
}:

let
  pname = "hamrs-pro";
  version = "2.44.0";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-linux-x86_64.AppImage";
      hash = "sha256-JDJxiOYgSHEBT0cyTlD/lalI4cQIODK06eaI+iVRDCI=";
    };

    aarch64-linux = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-linux-arm64.AppImage";
      hash = "sha256-umm+PEBcY1zVlxG0z585+PxW5gHuGxEtfj8zzIYwgAQ=";
    };

    x86_64-darwin = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-mac-x64.dmg";
      hash = "sha256-DN2Alc2dMeNyr0VtXzwd4BamtZev+gHBesf5ohM5wm0=";
    };

    aarch64-darwin = fetchurl {
      url = "https://hamrs-dist.s3.amazonaws.com/hamrs-pro-${version}-mac-arm64.dmg";
      hash = "sha256-JE1F6qHOmGGcfq6lNpiBr6hoK0UPy5S/VzOjhvsjgp4=";
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
      "x86_64-darwin"
    ];
  };

  linux = appimageTools.wrapType2 rec {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    extraInstallCommands =
      let
        contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';
  };

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

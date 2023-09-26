{
  appimageTools,
  fetchurl,
  lib,
}: let
  pname = "upscayl";
  version = "2.8.6";

  src = fetchurl {
    url = "https://github.com/upscayl/upscayl/releases/download/v${version}/upscayl-${version}-linux.AppImage";
    hash = "sha256-w5rjLqdlPOZWgdc2t0Y3tl24qZqpjBV6I9gruLaI+qc=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [vulkan-headers vulkan-loader];

    extraInstallCommands = ''
      mkdir -p $out/share/{applications,pixmaps}

      cp ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      cp ${appimageContents}/${pname}.png $out/share/pixmaps/${pname}.png

      mv $out/bin/${pname}-${version} $out/bin/${pname}

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';

    meta = with lib; {
      description = "Free and Open Source AI Image Upscaler";
      homepage = "https://upscayl.github.io/";
      maintainers = with maintainers; [icy-thought];
      license = licenses.agpl3Plus;
      platforms = platforms.linux;
    };
  }

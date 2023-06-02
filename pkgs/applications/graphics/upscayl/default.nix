{ appimageTools, fetchurl, lib }:

let
  pname = "upscayl";
  version = "2.5.1";
  src = fetchurl {
    url =
      "https://github.com/upscayl/upscayl/releases/download/v${version}/upscayl-${version}-linux.AppImage";
    sha256 = "sha256-mAMq7I7oH9BBJeLUT4mGxlh7vPNPwa6JeQUHnGoCgdc=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ vulkan-headers vulkan-loader ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm644 ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -Dm644 ${appimageContents}/${pname}.png $out/share/pixmaps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
  '';

  meta = {
    description = "Free, open-source AI image upscaler";
    homepage = "https://upscayl.github.io";
    maintainers = with lib.maintainers; [ zopieux ];
    license = lib.licenses.agpl3;
    platforms = lib.platforms.linux;
  };
}

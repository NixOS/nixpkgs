{
  lib,
  appimageTools,
  fetchurl,
  fontconfig,
  libdeflate,
  libsoup_3,
  webkitgtk_4_1,
  zstd,
}:

let
  pname = "creality-print";
  version = "7.2.1";
  upstreamVersion = "${version}.5476";

  src = fetchurl {
    url = "https://github.com/CrealityOfficial/CrealityPrint/releases/download/v${version}/CrealityPrint-V${upstreamVersion}-x86_64-Release.AppImage";
    hash = "sha256-so9mwl0MZlLtauSdB2Z4D0aluDm5POGWjmOYI+H24vM=";
  };

  # Creality statically links FreeType 2.12.1. Fontconfig 2.18 resolves
  # against that copy and crashes while wxWidgets registers its private font.
  fontconfigCompat = fontconfig.overrideAttrs (oldAttrs: {
    version = "2.17.1";
    src = fetchurl {
      url = "https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/2.17.1/fontconfig-2.17.1.tar.xz";
      hash = "sha256-n1yuk/T//B+8Ba6ZzfxwjNYN/WYS/8BRKCcCXAJvpUE=";
    };
    postInstall = oldAttrs.postInstall + ''
      substituteInPlace "$out/etc/fonts/fonts.conf" \
        --replace-fail '/etc/fonts/conf.d' "$out/etc/fonts/conf.d"
    '';
  });

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace "$out/AppRun" \
        --replace-fail 'export LD_LIBRARY_PATH="$DIR/bin:$DIR/usr/lib"' \
        'export LD_LIBRARY_PATH="$DIR/bin:$DIR/usr/lib:/usr/lib64"'
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  profile = ''
    export FONTCONFIG_FILE=${fontconfigCompat.out}/etc/fonts/fonts.conf
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
  '';

  extraPkgs = _: [
    fontconfigCompat
    libdeflate
    libsoup_3
    webkitgtk_4_1
    zstd
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/CrealityPrint.desktop \
      $out/share/applications/CrealityPrint.desktop
    install -Dm444 ${appimageContents}/CrealityPrint.png \
      $out/share/icons/hicolor/192x192/apps/CrealityPrint.png
    substituteInPlace $out/share/applications/CrealityPrint.desktop \
      --replace-fail 'Exec=AppRun %F' 'Exec=${pname} %F'
  '';

  passthru = { inherit src; };

  meta = {
    description = "Slicer for Creality FDM 3D printers";
    homepage = "https://github.com/CrealityOfficial/CrealityPrint";
    changelog = "https://github.com/CrealityOfficial/CrealityPrint/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ asamonik ];
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}

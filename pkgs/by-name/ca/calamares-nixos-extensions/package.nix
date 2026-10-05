{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  glibcLocales,
  imagemagick,
  librsvg,

  optimizeSvgGraphics ? true,
  svgo,
}:

let
  screenshots = stdenvNoCC.mkDerivation {
    name = "calamares-nixos-screenshots";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "calamares-nixos-extensions";
      rev = "63620df329c29fafc4928414fcde5d73f5b24f31";
      rootDir = "config/images";
      sparseCheckout = [
        "/config/images"
        "!/config/images/lumina.png"
      ];
      hash = "sha256-DFIkkNQKQBSt9Nd0/8vRa+QvIaAYI507uBvSFHVblKo=";
    };

    nativeBuildInputs = [
      imagemagick
    ];

    buildPhase = ''
      runHook preBuild

      magick -monitor '*.png' -quality 90 -set filename:fn '%[basename]' '%[filename:fn].webp'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/calamares/branding/nixos/images/screenshots
      cp -rv *.webp $out/share/calamares/branding/nixos/images/screenshots

      runHook postInstall
    '';

    meta = {
      license = with lib.licenses; [
        # Images stored in config/images are licensed under CC-BY-SA-4.0
        cc-by-sa-40
      ];
    };
  };

  branding = stdenvNoCC.mkDerivation {
    name = "calamares-nixos-branding";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nixos-homepage";
      rev = "986c850136825fd66234aa5dc527d9e155924998";
      rootDir = "core/src/assets/image";
      sparseCheckout = [
        "core/src/assets/image/landing/features/*.svg"
        "core/src/assets/image/nixos-logomark-default-gradient-none.svg"
        "core/src/assets/image/nixos-logomark-white-flat-none.svg"
      ];
      hash = "sha256-uld1akG5Zog94OY14rb+Y6kXYpM9WO+PJZNn4R2uu+w=";
    };

    nativeBuildInputs = [ librsvg ] ++ lib.optionals optimizeSvgGraphics [ svgo ];

    buildPhase = lib.optionalString optimizeSvgGraphics ''
      runHook preBuild

      # used as productLogo in branding.desc
      # aspect ratio is broken when using the SVG directly
      rsvg-convert \
        --keep-aspect-ratio \
        --width 320 \
        --height 320 \
        --format png \
        -o nixos-logomark-white-flat-none-320.png \
        nixos-logomark-white-flat-none.svg

      ${lib.optionalString optimizeSvgGraphics ''
        svgo --recursive --folder .
      ''}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/calamares/branding/nixos/images/{logomark,features}
      cp -rv nixos-logomark-*.{svg,png} $out/share/calamares/branding/nixos/images/logomark
      cp -rv landing/features/*.svg $out/share/calamares/branding/nixos/images/features

      runHook postInstall
    '';

    meta = {
      license = with lib.licenses; [
        # NixOS logomark
        cc-by-40
        # Feature SVGs from the homepage
        cc-by-sa-40
      ];
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "calamares-nixos-extensions";
  version = "0.3.23";

  src = ./src;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{etc,lib,share}/calamares
    cp -r modules $out/lib/calamares/
    cp -r config/* $out/etc/calamares/
    cp -r branding $out/share/calamares/

    substituteInPlace $out/etc/calamares/settings.conf --replace-fail @out@ $out
    substituteInPlace $out/etc/calamares/modules/locale.conf --replace-fail @glibcLocales@ ${glibcLocales}

    substituteInPlace $out/etc/calamares/modules/packagechooser.conf \
      --replace-fail @screenshots@ ${screenshots}/share/calamares/branding/nixos/images/screenshots
    substituteInPlace $out/share/calamares/branding/nixos/{branding.desc,show.qml} \
      --replace-fail @branding@ ${branding}/share/calamares/branding/nixos/images

    runHook postInstall
  '';

  passthru = {
    inherit screenshots branding;
  };

  meta = {
    description = "Calamares modules for NixOS";
    homepage = "https://github.com/NixOS/calamares-nixos-extensions";
    license =
      with lib.licenses;
      [
        mit
        cc0
      ]
      ++ screenshots.meta.license
      ++ branding.meta.license;
    maintainers = with lib.maintainers; [ vlinkz ];
    platforms = lib.platforms.linux;
  };
})

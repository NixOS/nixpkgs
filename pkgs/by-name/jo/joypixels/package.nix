{
  lib,
  stdenv,
  fetchurl,
  config,
  acceptLicense ? config.joypixels.acceptLicense or false,
}:

let
  inherit (stdenv.hostPlatform.parsed) kernel;

  systemSpecific =
    {
      darwin = rec {
        systemTag = "nix-darwin";
        capitalized = systemTag;
        fontFile = "joypixels-sbix.ttf";
      };
    }
    .${kernel.name} or {
      systemTag = "nixos";
      capitalized = "NixOS";
      fontFile = "joypixels-android.ttf";
    };

  joypixels-free-license =
    let
      inherit (systemSpecific) systemTag;
    in
    lib.licenses.mkLicense {
      shortName = "JoyPixels-Free";
      fullName = "JoyPixels Free License Agreement";
      url = "https://cdn.joypixels.com/distributions/${systemTag}/license/free-license.txt";
      free = false;
    };

  joypixels-license-appendix =
    let
      inherit (systemSpecific)
        capitalized
        systemTag
        ;
    in
    lib.licenses.mkLicense {
      shortName = "JoyPixels-NixOS-Appendix";
      fullName = "JoyPixels ${capitalized} License Appendix";
      url = "https://cdn.joypixels.com/distributions/${systemTag}/appendix/joypixels-license-appendix.txt";
      free = false;
      redistributable = true;
    };

  throwLicense = throw ''
    Use of the JoyPixels font requires acceptance of the license.
      - ${joypixels-free-license.fullName} [1]
      - ${joypixels-license-appendix.fullName} [2]

    You can express acceptance by setting acceptLicense to true in your
    configuration. Note that this is not a free license so it requires allowing
    unfree licenses.

    configuration.nix:
      nixpkgs.config.allowUnfreePackages = [
        "joypixels"
      ];
      nixpkgs.config.joypixels.acceptLicense = true;

    config.nix:
      allowUnfreePackages = [
        "joypixels"
      ];
      joypixels.acceptLicense = true;

    [1]: ${joypixels-free-license.url}
    [2]: ${joypixels-license-appendix.url}
  '';

in

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "11.0.0";

  src =
    assert !acceptLicense -> throwLicense;
    with systemSpecific;
    fetchurl {
      name = fontFile;
      url = "https://cdn.joypixels.com/distributions/${systemTag}/font/${version}/${fontFile}";
      sha256 =
        {
          darwin = "sha256-NDxhHgnHDenHict39V4W8mLJIqpmBfmDYfsRx7Es06s=";
        }
        .${kernel.name} or "sha256-taHKy2rin1SE24BKnB8LZ662U8MO9HL5if3+mHQ38Io=";
    };

  dontUnpack = true;

  installPhase = with systemSpecific; ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/${fontFile}

    runHook postInstall
  '';

  meta = {
    description = "Finest emoji you can use legally (formerly EmojiOne)";
    longDescription = ''
      Updated for 2026! 3,991 originally-crafted emoji, Unicode 17 compatible.
    '';
    homepage = "https://www.joypixels.com/fonts";
    hydraPlatforms = [ ]; # Just a binary file download, nothing to cache.
    license = lib.licenses.WITH joypixels-free-license joypixels-license-appendix;
    maintainers = with lib.maintainers; [
      toonn
      jtojnar
    ];
    # Not quite accurate since it's a font, not a program, but clearly
    # indicates we're not actually building it from source.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}

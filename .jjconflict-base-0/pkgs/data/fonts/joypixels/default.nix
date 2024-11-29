{ lib, stdenv
, fetchurl
, config
, acceptLicense ? config.joypixels.acceptLicense or false
}:

let
  inherit (stdenv.hostPlatform.parsed) kernel;

  systemSpecific = {
    darwin = rec {
      systemTag =  "nix-darwin";
      capitalized = systemTag;
      fontFile = "JoyPixels-SBIX.ttf";
    };
  }.${kernel.name} or rec {
    systemTag = "nixos";
    capitalized = "NixOS";
    fontFile = "joypixels-android.ttf";
  };

  joypixels-free-license = with systemSpecific; {
    spdxId = "LicenseRef-JoyPixels-Free";
    fullName = "JoyPixels Free License Agreement";
    url = "https://cdn.joypixels.com/free-license.pdf";
    free = false;
  };

  joypixels-license-appendix = with systemSpecific; {
    spdxId = "LicenseRef-JoyPixels-NixOS-Appendix";
    fullName = "JoyPixels ${capitalized} License Appendix";
    url = "https://cdn.joypixels.com/distributions/${systemTag}/appendix/joypixels-license-appendix.pdf";
    free = false;
  };

  throwLicense = throw ''
    Use of the JoyPixels font requires acceptance of the license.
      - ${joypixels-free-license.fullName} [1]
      - ${joypixels-license-appendix.fullName} [2]

    You can express acceptance by setting acceptLicense to true in your
    configuration. Note that this is not a free license so it requires allowing
    unfree licenses.

    configuration.nix:
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "joypixels"
        ];
      nixpkgs.config.joypixels.acceptLicense = true;

    config.nix:
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "joypixels"
      ];
      joypixels.acceptLicense = true;

    [1]: ${joypixels-free-license.url}
    [2]: ${joypixels-license-appendix.url}
  '';

in

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "8.0.0";

  src = assert !acceptLicense -> throwLicense;
    with systemSpecific; fetchurl {
      name = fontFile;
      url = "https://cdn.joypixels.com/distributions/${systemTag}/font/${version}/${fontFile}";
      sha256 = {
        darwin = "0kj4nck6k91avhan9iy3n8hhk47xr44rd1lzljjx3w2yzw1w9zvv";
      }.${kernel.name} or "1bkyclgmvl6ppbdvidc5xr1g6f215slf0glnh5p6fsfbxc5h95bw";
    };

  dontUnpack = true;

  installPhase = with systemSpecific; ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/${fontFile}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Finest emoji you can use legally (formerly EmojiOne)";
    longDescription = ''
      Updated for 2023! JoyPixels 8.0 includes 3,702 originally crafted icon
      designs and is 100% Unicode 15.0 compatible. We offer the largest
      selection of files ranging from png, svg, iconjar, and fonts (sprites
      available upon request).
    '';
    homepage = "https://www.joypixels.com/fonts";
    hydraPlatforms = []; # Just a binary file download, nothing to cache.
    license =
      let
        free-license = joypixels-free-license;
        appendix = joypixels-license-appendix;
      in with systemSpecific; {
        spdxId = "LicenseRef-JoyPixels-Free-with-${capitalized}-Appendix";
        fullName = "${free-license.fullName} with ${appendix.fullName}";
        url = free-license.url;
        appendixUrl = appendix.url;
        free = false;
      };
    maintainers = with maintainers; [ toonn jtojnar ];
    # Not quite accurate since it's a font, not a program, but clearly
    # indicates we're not actually building it from source.
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}

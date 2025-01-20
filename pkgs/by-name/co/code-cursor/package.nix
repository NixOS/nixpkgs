{
  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
}:

let
  pname = "cursor";
  version = "0.44.11";

  inherit (stdenvNoCC) hostPlatform;

  sources = {
    x86_64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-x86_64.AppImage";
      hash = "sha256-eOZuofnpED9F6wic0S9m933Tb7Gq7cb/v0kRDltvFVg=";
    };
    aarch64-linux = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/cursor-0.44.11-build-250103fqxdt5u9z-arm64.AppImage";
      hash = "sha256-mxq7tQJfDccE0QsZDZbaFUKO0Xc141N00ntX3oEYRcc=";
    };
    x86_64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.44.11%20-%20Build%20250103fqxdt5u9z-x64.dmg";
      hash = "sha256-JKPClcUD2W3KWRlRTomDF4FOOA1DDw3iAQ+IH7yan+E=";
    };
    aarch64-darwin = fetchurl {
      url = "https://download.todesktop.com/230313mzl4w4u92/Cursor%200.44.11%20-%20Build%20250103fqxdt5u9z-arm64.dmg";
      hash = "sha256-0HDnRYfy+jKJy5dvaulQczAoFqYmGGWcdhIkaFZqEPA=";
    };
  };

  source = sources.${hostPlatform.system};

  meta = {
    description = "AI-powered code editor built on vscode";
    homepage = "https://cursor.com";
    changelog = "https://cursor.com/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      sarahec
      aspauldingcode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cursor";
  };

in
if hostPlatform.isLinux then
  callPackage ./linux.nix {
    inherit
      sources
      source
      pname
      version
      meta
      ;
  }
else
  callPackage ./darwin.nix {
    inherit
      sources
      source
      pname
      version
      meta
      ;
  }

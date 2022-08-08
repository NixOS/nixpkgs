{ lib, stdenv, callPackage, fetchurl, nixosTests }:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "0vwnx7fs46fkas75pnhjc81wy3hr24k2gs82i30ailaxw5r63j81";
    x86_64-darwin = "0bxc74vfkw9zhxfahzhcghlnybvj8k15jbni489lf636a45xrlcc";
    aarch64-linux = "10z6nv67yjd15ilxgfpjf07qbdp0cbd5761a5gcymiam4r22l6hq";
    aarch64-darwin = "133nccm0hcgcd2503psxwaaq4v4l16q7w7kbcz1y5lynlvwazjrx";
    armv7l-linux = "1sx3l42ls62v3apjap25ccg4mcbi71spfj5xh7y6rffzi65xwdrv";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.70.0";
    pname = "vscodium";

    executableName = "codium";
    longName = "VSCodium";
    shortName = "vscodium";

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
      inherit sha256;
    };

    tests = nixosTests.vscodium;

    updateScript = ./update-vscodium.sh;

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS (VS Code without MS branding/telemetry/licensing)
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = "https://github.com/VSCodium/vscodium";
      downloadPage = "https://github.com/VSCodium/vscodium/releases";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      maintainers = with maintainers; [ synthetica turion bobby285271 ];
      mainProgram = "codium";
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
    };
  }

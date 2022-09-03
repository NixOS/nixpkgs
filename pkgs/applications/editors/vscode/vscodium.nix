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
    x86_64-linux = "03lbfl3azrjhxzkadrz632dpwnv6hyyls10mc8wzspwraz77v1m5";
    x86_64-darwin = "1fd66fbs414lja7ca38sdgx02nw9w1qfrlxhcb52ijls5xbmbgm4";
    aarch64-linux = "0hwzx0lvrxrzrpggpsymjzy53dq4msg0j3vrxq82308ydc5ssnzd";
    aarch64-darwin = "0dqhi6br29bq8a97wgfxgz4d236cg0ydgaqv8j5nqjgvjwp13p9l";
    armv7l-linux = "07qq0ic9nckl9fkk5rl9dy4gksw3l248jsy7v8ws8f3mq4l8gi49";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.71.0.22245";
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

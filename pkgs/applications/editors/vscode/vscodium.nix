{ lib, stdenv, callPackage, fetchurl, nixosTests, commandLineArgs ? "" }:

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
    x86_64-linux = "01b6w97miai191b2d1lr7cwv36vjvwv1hjggr0g9gfr5j99yzdw3";
    x86_64-darwin = "1vf6sdm19r1d6a6ljz3jlvqddgyrdqcxpha4x80ar3kwddy254kb";
    aarch64-linux = "1i48lck395i6lzcxwzfhijs5d141wnxbxg5rzgprm2hgkqx836nr";
    aarch64-darwin = "02xvb41i8ri8l9w8cxxviz63mkskkmxn6rwprpbglpbpxncsxgbn";
    armv7l-linux = "0s0zlql652fwfz94bqmnrl77agd8gf6i5w1y09jpvcc33wv0zlgw";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot commandLineArgs;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.72.1.22284";
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

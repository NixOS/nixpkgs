{ stdenv, lib, callPackage, fetchurl, nixosTests
, isInsiders ? false
, commandLineArgs ? ""
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  channel = if isInsiders then "insider" else "stable";
  channelSuffix = lib.optionalString isInsiders "-insiders";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    stable-x86_64-linux = "0bc95mdl19la63yvqrpfcvq9sx68wfv60a3xrz2z5lk308khfpr6";
    stable-x86_64-darwin = "0qb8610ilf69j0zl7z031bmqdsxsj15w1maz7lx0z09yrdyvgi7c";
    stable-aarch64-linux = "157arn7wsxgh3qr4bzhy75y7zw9qwz1zch7ny36kr53135d2nhz6";
    stable-aarch64-darwin = "0dwzqv1j1gcjyc1w41f9k1pijazr62r569arh4l53xi7amrp7hx8";
    stable-armv7l-linux = "1lam1z8hqdav4al07d1ahq4qh2npv191n2gqpdxg5b1fs7zv3k85";

    insider-x86_64-linux = "10dp68wl6vba2sgka4j6bkr2vzbmgcq2lppp1nhqm9fh4skixvl6";
    insider-x86_64-darwin = "0n6fyz0ij26bd0xchg92i3qgrgf41xqsx0hr727img9lccpc0hvi";
    insider-aarch64-linux = "1ay5scqcmd7mz16l83xbfim2h51nyvz0s1v1yjzyz0p7gqaig994";
    insider-aarch64-darwin = "0l97i5zc3r422ph29dpq0d1h2yy99r74jy4w7w5lcyc2khi55xlb";
    insider-armv7l-linux = "19s13shbr6v6dllpaq4rpmlcj0dysx1p9lgfpcarjdwsca5a03gn";
  }."${channel}-${system}" or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot commandLineArgs;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = if isInsiders then "1.73.0.22295-insider" else "1.72.2.22289";
    pname = "vscodium";

    executableName = "codium" + channelSuffix;
    longName = "VSCodium" + lib.optionalString isInsiders " - Insiders";
    shortName = "Codium" + lib.optionalString isInsiders " - Insiders";

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium${channelSuffix}/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
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
      maintainers = with maintainers; [ synthetica turion bobby285271 weathercold ];
      mainProgram = "codium" + channelSuffix;
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
    };
  }

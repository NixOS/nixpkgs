{ stdenv, lib, callPackage, fetchurl
, isInsiders ? false
, commandLineArgs ? ""
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  channel = if isInsiders then "insider" else "stable";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    stable-x86_64-linux = "0cf6zlwslii30877p5vb0varxs6ai5r1g9wxx1b45yrmp7rvda91";
    stable-x86_64-darwin = "0j9kb7j2rvrgc2dzxhi1nzs78lzhpkfk3gcqcq84hcsga0n59y03";
    stable-aarch64-linux = "1bf2kvnd2pz2sk26bq1wm868bvvmrg338ipysmryilhk0l490vcx";
    stable-aarch64-darwin = "1rwwrzabxgw2wryi6rp8sc1jqps54p7a3cjpn4q94kds8rk5j0qn";
    stable-armv7l-linux = "0p2kwfq74lz43vpfh90xfrqsz7nwgcjsvqwkifkchp1m3xnil742";

    insider-x86_64-linux = "08yw98bcj7d1v2shapgddsc2ma8jxl7xnyq8nvgqb4cqw8nmd4p6";
    insider-x86_64-darwin = "08wizyz65abg8frl2v0vzxl4wy0m0zb90rhz636n3kwbzzxyd5d4";
    insider-aarch64-linux = "0v14yshs816qspffs1gh7mk0jv6m5jmabjfnwmdsljqnf23hj221";
    insider-aarch64-darwin = "1jcblhr7565d2kzsazskdlrzylxfcmci8npd5g38v1znmpgrmby9";
    insider-armv7l-linux = "00w6kmafpssm70l58ivp0gcdql8g7w4dbzah7iw3cr1qnhjpxc5i";
  }."${channel}-${system}" or throwSystem;
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = if isInsiders then "1.73.0-insider" else "1.72.2";
    pname = "vscode";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";
    inherit commandLineArgs;

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/${channel}";
      inherit sha256;
    };

    sourceRoot = "";

    updateScript = ./update-vscode.sh;

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      mainProgram = if isInsiders then "code-insiders" else "code";
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = "https://code.visualstudio.com/";
      downloadPage = "https://code.visualstudio.com/Updates";
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu synthetica maxeaubrey bobby285271 weathercold ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }

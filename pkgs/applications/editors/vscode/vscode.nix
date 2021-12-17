{ stdenv, lib, callPackage, fetchurl, isInsiders ? false }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "0xn2gcvqjbj2adfwq2s0pz1n4yxg6spq4hifhvwavb34pn9yc9p9";
    x86_64-darwin = "13kgsxhjdfcdgz8xbhzpd7x1xh6am255dwxpbr03cg4p8iwfd3ig";
    aarch64-linux = "166ag0k0j8wixm3arl1ld4a4qi92ff1zvb6whhqshzdv0s39pys3";
    aarch64-darwin = "08g8qjbvlp27i37z7jcsvzgg6vm0grppnlh0jyji6lz31ksib6pz";
    armv7l-linux = "15l9kr01f0jxfi0a9dnldsjrwzv9x60ljgvmlh0zhx4h0q1x0n7l";
  }.${system};
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.63.1";
    pname = "vscode";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };

    sourceRoot = "";

    updateScript = ./update-vscode.sh;

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      mainProgram = "code";
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
      maintainers = with maintainers; [ eadwu synthetica maxeaubrey bobby285271 ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }

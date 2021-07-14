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
    x86_64-linux = "1879r3kfmvldlcb9hhrh2s77ack750hrdvhx78bryf8xcknnij7n";
    x86_64-darwin = "04v7naackdp56j4y0n0hwq4073pjsmxbg4fhfg801iaw2q5277cs";
    aarch64-linux = "1zxwzgg42markbzrwq2mnr1p6w5zq5wzynz6f8hj0ihp5cvbs1qc";
    aarch64-darwin = "1c0q2dsdrgdjx0gmcvf3lsz5w03316n46yzcm9kbv3lm8wwz1zhb";
    armv7l-linux = "1v2nnglswi7wqak62i4pamsf35k1ny12x61s06c63q5cqwhwz87k";
  }.${system};
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.58.1";
    pname = "vscode";

    sourceExecutableName = "code";
    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };

    sourceRoot = "";

    updateScript = ./update-vscodium.sh;

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
      maintainers = with maintainers; [ eadwu synthetica ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }

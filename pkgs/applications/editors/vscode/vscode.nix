{ stdenv, lib, callPackage, fetchurl
, isInsiders ? false
, commandLineArgs ? ""
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "0f5l720gc47dygbk7mahx7pb088a8bfrnf69j3igvczbnfapx5sy";
    x86_64-darwin = "0qmji8bfnqvrxv4yk3rscvns1hk5wfwwdng8jblh5bilf657g1fc";
    aarch64-linux = "0qcmcsb97q303izhw8k4242nsb72my1vnf24hsfml4vr76f5qqbd";
    aarch64-darwin = "1cc8p5s8vr5bml715yx2lzkqa9q85rziswrhl1d11zagymvswjzn";
    armv7l-linux = "086c3wazjk30f8r8dgi0bjsvzcc6sa9d80cy4500pim7rb7s6ppn";
  }.${system} or throwSystem;
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.74.1";
    pname = "vscode";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";
    inherit commandLineArgs;

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };

    sourceRoot = "";

    updateScript = ./update-vscode.sh;

    # Editing the `code` binary within the app bundle causes the bundle's signature
    # to be invalidated, which prevents launching starting with macOS Ventura, because VS Code is notarized.
    # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
    dontFixup = stdenv.isDarwin;

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

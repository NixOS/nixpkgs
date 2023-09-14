{ stdenv
, lib
, callPackage
, fetchurl
, nixosTests
, srcOnly
, isInsiders ? false
# sourceExecutableName is the name of the binary in the source archive over
# which we have no control and it is needed to run the insider version as
# documented in https://nixos.wiki/wiki/Visual_Studio_Code#Insiders_Build
# On MacOS the insider binary is still called code instead of code-insiders as
# of 2023-08-06.
, sourceExecutableName ? "code" + lib.optionalString (isInsiders && stdenv.isLinux) "-insiders"
, commandLineArgs ? ""
, useVSCodeRipgrep ? stdenv.isDarwin
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
    x86_64-linux = "1gqpsgg6fsfssn03213sn31qcb5xnfnn3hd5g8j2mxfd0dyjgyir";
    x86_64-darwin = "0h0mj3vdnwcdxk9cnss4v8mmcfhm1yknm1al8c2047wjsj8w4jmm";
    aarch64-linux = "0qrph1a0cbr7sqx0qv4v05himsphlpwd1lgyliwqxzl8yxka8nwv";
    aarch64-darwin = "0mjqy08v0idck7a05w8rinfccg7vn50z6b0jrvp2m5q2122c0rcc";
    armv7l-linux = "1gp29rzc2iyl7vw2hlfjn5770mfpa6n9vc3f776msdxwrsia6xg9";
  }.${system} or throwSystem;
in
  callPackage ./generic.nix rec {
    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.82.0";
    pname = "vscode" + lib.optionalString isInsiders "-insiders";

    # This is used for VS Code - Remote SSH test
    rev = "8b617bd08fd9e3fc94d14adb8d358b56e3f72314";

    executableName = "code" + lib.optionalString isInsiders "-insiders";
    longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
    shortName = "Code" + lib.optionalString isInsiders " - Insiders";
    inherit commandLineArgs useVSCodeRipgrep sourceExecutableName;

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };

    # We don't test vscode on CI, instead we test vscodium
    tests = {};

    sourceRoot = "";

    # As tests run without networking, we need to download this for the Remote SSH server
    vscodeServer = srcOnly {
      name = "vscode-server-${rev}.tar.gz";
      src = fetchurl {
        name = "vscode-server-${rev}.tar.gz";
        url = "https://update.code.visualstudio.com/commit:${rev}/server-linux-x64/stable";
        sha256 = "192af63q9nklgsai71bss2bisc4wip1gbzmlpdvcjpi1hkspab2v";
      };
    };

    tests = { inherit (nixosTests) vscode-remote-ssh; };

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
      maintainers = with maintainers; [ eadwu synthetica amaxine bobby285271 Enzime ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }

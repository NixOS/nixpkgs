{
  lib,
  stdenv,
  stdenvNoCC,
  callPackage,
  fetchurl,
  nixosTests,
  srcOnly,
  isInsiders ? false,
  # sourceExecutableName is the name of the binary in the source archive over
  # which we have no control and it is needed to run the insider version as
  # documented in https://wiki.nixos.org/wiki/Visual_Studio_Code#Insiders_Build
  # On MacOS the insider binary is still called code instead of code-insiders as
  # of 2023-08-06.
  sourceExecutableName ?
    "code" + lib.optionalString (isInsiders && stdenv.hostPlatform.isLinux) "-insiders",
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      x86_64-darwin = "darwin";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
      armv7l-linux = "linux-armhf";
    }
    .${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  hash =
    {
      x86_64-linux = "sha256-nPE1RRF8KX3OVQ6xh3lcYIpr2tHWrLyEUNrOtuBsvb0=";
      x86_64-darwin = "sha256-maDHlhn5/+gZkdt4Mhmvf6Tj3X6BCqLt5A17yQF+vbM=";
      aarch64-linux = "sha256-3ApT/xg9PL76x9NGfin4rSX/Y+HQXofWV8Z0PM1s8Nw=";
      aarch64-darwin = "sha256-mBHKXBJZcXBgO9L86gUQpLLXbN97/mRiONkUs/Qtl78=";
      armv7l-linux = "sha256-GJVRMgeppr9G1S0JsaE/SFrTgJdlw8sd0zqBFxvFMmc=";
    }
    .${system} or throwSystem;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.107.0";

  # This is used for VS Code - Remote SSH test
  rev = "618725e67565b290ba4da6fe2d29f8fa1d4e3622";
in
callPackage ./generic.nix {
  pname = "vscode" + lib.optionalString isInsiders "-insiders";

  executableName = "code" + lib.optionalString isInsiders "-insiders";
  longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
  shortName = "Code" + lib.optionalString isInsiders " - Insiders";
  inherit
    version
    rev
    commandLineArgs
    useVSCodeRipgrep
    sourceExecutableName
    ;

  src = fetchurl {
    name = "VSCode_${version}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
    inherit hash;
  };

  # We don't test vscode on CI, instead we test vscodium
  tests = { };

  sourceRoot = "";

  # As tests run without networking, we need to download this for the Remote SSH server
  vscodeServer = srcOnly {
    name = "vscode-server-${rev}.tar.gz";
    src = fetchurl {
      name = "vscode-server-${rev}.tar.gz";
      url = "https://update.code.visualstudio.com/commit:${rev}/server-linux-x64/stable";
      hash = "sha256-m0gJ77a0h0daCnIM90L7XNoCfxLv2VOkDZfpJEP/QVM=";
    };
    stdenv = stdenvNoCC;
  };

  tests = { inherit (nixosTests) vscode-remote-ssh; };

  updateScript = ./update-vscode.sh;

  # Editing the `code` binary within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because VS Code is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  hasVsceSign = true;

  meta = {
    description = "Code editor developed by Microsoft";
    mainProgram = "code";
    longDescription = ''
      Code editor developed by Microsoft. It includes support for debugging,
      embedded Git control, syntax highlighting, intelligent code completion,
      snippets, and code refactoring. It is also customizable, so users can
      change the editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://code.visualstudio.com/";
    downloadPage = "https://code.visualstudio.com/Updates";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      eadwu
      synthetica
      bobby285271
      johnrtitor
      jefflabonte
      wetrustinprize
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
}

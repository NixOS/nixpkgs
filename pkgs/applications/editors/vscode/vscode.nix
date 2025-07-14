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
      x86_64-linux = "sha256-72KrCDUBe+xJjnSY/nnrNH92EP4tp71x1fadh0Pe0DM=";
      x86_64-darwin = "sha256-Ua3oh0Hv0oiW15u3Rb0pSYu+JD8m1oYMAm5pEzXD6Rw=";
      aarch64-linux = "sha256-5L0ZArj+7M5dhZDGzYj6NaxYYZEb8q89Vhngvjuw7wQ=";
      aarch64-darwin = "sha256-uWOF/QGgXocKZAkFMN4Kh7HjiQTSIi+PVPy3V90wrAA=";
      armv7l-linux = "sha256-FyGPvQeVz8yLhLjFGtCXPTVPvCB0/EX6pRe5RCAmXTU=";
    }
    .${system} or throwSystem;
in
callPackage ./generic.nix rec {
  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.101.2";
  pname = "vscode" + lib.optionalString isInsiders "-insiders";

  # This is used for VS Code - Remote SSH test
  rev = "2901c5ac6db8a986a5666c3af51ff804d05af0d4";

  executableName = "code" + lib.optionalString isInsiders "-insiders";
  longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
  shortName = "Code" + lib.optionalString isInsiders " - Insiders";
  inherit commandLineArgs useVSCodeRipgrep sourceExecutableName;

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
      hash = "sha256-Bocoiz8pxQNAZxmWdOgh+y44QTnqvDjcqFCodny7VoY=";
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
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      eadwu
      synthetica
      bobby285271
      johnrtitor
      jefflabonte
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

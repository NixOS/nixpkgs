{
  lib,
  callPackage,
  pkgs,
  ...
}:
let
  # Define version and source information
  version = "1.2.6";
  sha256 = "sha256-rXHrArkwLUzxQTwKg3Y/Rf5FXlvnTunhR3vqLoWgLKo="; # Change variable name from sha256Hash to sha256
in

callPackage (pkgs.path + "/pkgs/applications/editors/vscode/generic.nix") {
  pname = "code-windsurf";
  version = version;
  src = pkgs.fetchurl {
    inherit sha256;
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/d08b8ea13d580d24be204c76e5dd1651d7234cd2/Windsurf-linux-x64-${version}.tar.gz";
  };
  sourceRoot = "Windsurf";
  executableName = "windsurf";
  commandLineArgs = "";
  meta = with lib; {
    description = "Windsurf - AI-powered code editor built on vscode";
    longDescription = "The Windsurf Editor is built for the way AI is meant to work with humans. Everything you love in Codeium and more, with unmatched performance and a user experience that keeps you in the flow.";
    homepage = "https://codeium.com/";
    changelog = "https://codeium.com/changelog";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
    mainProgram = "windsurf";
    maintainers = with maintainers; [ joyanhui ];
  };
  updateScript = "";
  longName = "Windsurf - Agentic IDE";
  shortName = "windsurf";
}

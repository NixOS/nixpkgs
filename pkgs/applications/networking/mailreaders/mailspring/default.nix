{
  lib,
  stdenv,
  callPackage,
}:
let
  pname = "mailspring";
  version = "1.13.3";

  meta = with lib; {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    homepage = "https://getmailspring.com";
    license = licenses.gpl3Plus;
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine runs locally, but its source is not open.
    '';
    mainProgram = "mailspring";
    maintainers = with maintainers; [ toschmidt ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };

  linux = callPackage ./linux.nix { inherit pname version meta; };
  darwin = callPackage ./darwin.nix { inherit pname version meta; };
in
if stdenv.hostPlatform.isDarwin then darwin else linux

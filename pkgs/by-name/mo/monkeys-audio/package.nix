{
  lib,
  stdenv,
  fetchzip,
  cmake,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "12.60";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    hash = "sha256-vlxXAyo0dMwkyr7SE/JWgUr0ANDhWCm4zg2i/p+GlSc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru = {
    updateScript = writeScript "update-monkeys-audio" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of "Monkey's Audio 12.58 SDK"'.
      newVersion="$(curl -s https://monkeysaudio.com/developers.html |
        pcregrep -o1 "Monkey's Audio ([0-9.]+) SDK")"
      update-source-version ${finalAttrs.pname} "$newVersion"
    '';
  };

  meta = {
    description = "APE codec and decompressor";
    platforms = lib.platforms.linux;
    mainProgram = "mac";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})

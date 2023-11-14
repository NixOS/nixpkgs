{ lib
, stdenv
, fetchzip
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  version = "10.26";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${
      builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    sha256 = "sha256-SXuuAavvqzZ7DRX6SKfPfC1smbTHVHUAv80w0RHLfpg=";
    stripRoot = false;
  };
  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "APE codec and decompressor";
    platforms = platforms.linux;
    mainProgram = "mac";
    # This is not considered a GPL license, but it seems rather free although
    # it's not standard, see a quote of it:
    # https://github.com/NixOS/nixpkgs/pull/171682#issuecomment-1120260551
    license = licenses.free;
    maintainers = with maintainers; [ doronbehar ];
  };
})

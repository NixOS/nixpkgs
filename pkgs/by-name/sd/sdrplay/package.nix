{
  callPackage,
  fetchurl,
  stdenv,
  lib,
}:

let
  version = "3.15.1";

  sources = rec {
    x86_64-linux = {
      url = "https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${version}.run";
      hash = "sha256-CTcyv10Xz9G2LqHh4qOW9tKBEcB+rztE2R7xJIU4QBQ=";
    };

    x86_64-darwin = {
      url = "https://www.sdrplay.com/software/SDRplayAPI-macos-installer-universal-3.15.1.pkg";
      hash = "sha256-XRSM7aH653XS0t9bP89G3uJ7YiLiU1xMBjwvLqL3rMM=";
    };

    aarch64-linux = x86_64-linux;
    aarch64-darwin = x86_64-darwin;
  };

  platforms = lib.attrNames sources;

  package = if stdenv.hostPlatform.isLinux then ./linux.nix else ./darwin.nix;

in

callPackage package {
  pname = "sdrplay";
  inherit version;

  src =
    let
      inherit (stdenv.hostPlatform) system;
      source =
        if lib.hasAttr system sources then
          sources."${system}"
        else
          throw "SDRplay is not supported on ${system}";

    in
    fetchurl source;

  meta = with lib; {
    inherit platforms;

    description = "SDRplay API";
    longDescription = ''
      Proprietary library and api service for working with SDRplay devices. For documentation and licensing details see
      https://www.sdrplay.com/docs/SDRplay_API_Specification_v${lib.concatStringsSep "." (lib.take 2 (builtins.splitVersion version))}.pdf
    '';

    homepage = "https://www.sdrplay.com/downloads/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      pmenke
      zaninime
    ];

    mainProgram = "sdrplay_apiService";
  };
}

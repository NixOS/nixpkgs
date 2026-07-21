{
  lib,
  stdenv,
  fetchurl,
}:
let
  arch_table = {
    "x86_64-linux" = "linux-x86_64";
    "i686-linux" = "linux-i686";
  };

  sha_table = {
    "x86_64-linux" = "d9902aadac4f442992877945da2a6fe8d6ea6b0de314ca8ac0c28dc5f253f7d8";
    "i686-linux" = "46deb0a053b4910c4e68737a7b6556ff5360260c8f86652f91a0130445f5c949";
  };

  throwSystem = throw "Unsupported system: ${stdenv.system}";
  arch = arch_table.${stdenv.system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "essentia-extractor";
  version = "2.1_beta2";

  src = fetchurl {
    url = "https://ftp.acousticbrainz.org/pub/acousticbrainz/essentia-extractor-v${finalAttrs.version}-${arch}.tar.gz";
    sha256 = sha_table.${stdenv.system} or throwSystem;
  };

  unpackPhase = "unpackFile $src ; export sourceRoot=.";

  installPhase = ''
    mkdir -p $out/bin
    cp streaming_extractor_music $out/bin
  '';

  meta = {
    homepage = "https://acousticbrainz.org/download";
    description = "AcousticBrainz audio feature extractor";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ lovesegfault ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "streaming_extractor_music";
  };
})

{
  lib,
  stdenv,
  fetchurl,
  libogg,
  libao,
  pkg-config,
  flac,
  opusfile,
  libopusenc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opus-tools";
  version = "0.2";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opus-tools-${finalAttrs.version}.tar.gz";
    sha256 = "11pzl27s4vcz4m18ch72nivbhww2zmzn56wspb7rll1y1nq6rrdl";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libogg
    libao
    flac
    opusfile
    libopusenc
  ];

  meta = {
    description = "Tools to work with opus encoded audio streams";
    homepage = "https://www.opus-codec.org/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})

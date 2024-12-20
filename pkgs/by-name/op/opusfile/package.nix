{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  openssl,
  libogg,
  libopus,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "opusfile";
  version = "0.12";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opusfile-${version}.tar.gz";
    sha256 = "02smwc5ah8nb3a67mnkjzqmrzk43j356hgj2a97s9midq40qd38i";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libogg
  ];
  propagatedBuildInputs = [ libopus ];
  outputs = [
    "out"
    "dev"
  ];
  patches =
    [
      ./include-multistream.patch
      (fetchpatch {
        name = "CVE-2022-47021.patch";
        url = "https://github.com/xiph/opusfile/commit/0a4cd796df5b030cb866f3f4a5e41a4b92caddf5.patch";
        sha256 = "sha256-XThI/ys5caB+OncFVfxm5IsvQPy1MbLQKwIlYjPvTJQ=";
      })
    ]
    # fixes problem with openssl 1.1 dependency
    # see https://github.com/xiph/opusfile/issues/13
    ++ lib.optionals stdenv.hostPlatform.isWindows [ ./disable-cert-store.patch ];
  configureFlags = [ "--disable-examples" ];

  meta = with lib; {
    description = "High-level API for decoding and seeking in .opus files";
    homepage = "https://www.opus-codec.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ taeer ];
  };
}

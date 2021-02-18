{ lib, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "lighthouse-bin";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/sigp/lighthouse/releases/download/v${version}/lighthouse-v${version}-x86_64-unknown-linux-gnu-portable.tar.gz";
    sha256 = "054d792g7lyv6g40d2qgg47d20881m5xidifk0fiw2aa21zbv9lm";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=$(pwd)";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D lighthouse $out/bin/
  '';

  meta = with lib; {
    description = "An open-source Ethereum 2.0 client, written in Rust.";
    homepage = "https://github.com/sigp/lighthouse";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = [ "x86_64-linux" ];
  };
}

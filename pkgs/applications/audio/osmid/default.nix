{ lib, stdenv
, fetchFromGitHub
, cmake
, alsa-lib
, libX11
}:

stdenv.mkDerivation rec {
  pname = "osmid";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "llloret";
    repo = "osmid";
    rev = "v${version}";
    sha256 = "1s1wsrp6g6wb0y61xzxvaj59mwycrgy52r4h456086zkz10ls6hw";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ alsa-lib libX11 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp {m2o,o2m} $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/llloret/osmid";
    description = "A lightweight, portable, easy to use tool to convert MIDI to OSC and OSC to MIDI";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    platforms = platforms.linux;
  };
}

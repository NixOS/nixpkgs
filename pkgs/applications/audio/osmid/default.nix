{ stdenv
, fetchFromGitHub
, cmake
, alsaLib
, libX11
}:

stdenv.mkDerivation rec {
  pname = "osmid";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "llloret";
    repo = "osmid";
    rev = "v${version}";
    sha256 = "1yl25abf343yvd49nfsgxsz7jf956zrsi5n4xyqb5ldlp2hifk15";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ alsaLib libX11 ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp {m2o,o2m} $out/bin/
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/llloret/osmid";
    description = "A lightweight, portable, easy to use tool to convert MIDI to OSC and OSC to MIDI";
    license = licenses.mit;
    maintainers = with maintainers; [ c0deaddict ];
    platforms = platforms.linux;
  };
}

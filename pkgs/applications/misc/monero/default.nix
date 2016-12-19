{ stdenv, fetchFromGitHub, cmake, boost, miniupnpc, pkgconfig, unbound }:

let
  version = "0.9.4";
in
stdenv.mkDerivation {
  name = "monero-${version}";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "bitmonero";
    rev = "v${version}";
    sha256 = "1qzpy1mxz0ky6hfk1gf67ybbr9xy6p6irh6zwri35h1gb97sbc3c";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ boost miniupnpc unbound ];

  # these tests take a long time and don't
  # always complete in the build environment
  postPatch = "sed -i '/add_subdirectory(tests)/d' CMakeLists.txt";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  doCheck = false;

  installPhase = ''
    install -Dt "$out/bin/" \
        bin/bitmonerod \
        bin/blockchain_converter \
        bin/blockchain_dump \
        bin/blockchain_export \
        bin/blockchain_import \
        bin/cn_deserialize \
        bin/simpleminer \
        bin/simplewallet
  '';

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage = http://monero.cc/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = [ "x86_64-linux" ];
  };
}

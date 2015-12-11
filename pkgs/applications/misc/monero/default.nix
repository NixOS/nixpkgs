{ stdenv, fetchurl, cmake, boost }:

let
  version = "0.8.8.4";
in
stdenv.mkDerivation {
  name = "monero-${version}";

  src = fetchurl {
    url = "https://github.com/monero-project/bitmonero/archive/v${version}.tar.gz";
    sha256 = "0bbhqjjzh922aymjqrnl2hd3r8x6p7x5aa5jidv3l4d77drhlgzy";
  };

  buildInputs = [ cmake boost ];

  # these tests take a long time and don't
  # always complete in the build environment
  postPatch = "sed -i '/add_subdirectory(tests)/d' CMakeLists.txt";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  doCheck = false;
  checkTarget = "test-release"; # this would be the target

  installPhase = ''
    install -Dt "$out/bin/" \
        src/bitmonerod \
        src/connectivity_tool \
        src/simpleminer \
        src/simplewallet
  '';

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage = http://monero.cc/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = [ "x86_64-linux" ];
  };
}

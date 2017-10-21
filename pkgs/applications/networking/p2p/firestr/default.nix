{ stdenv, fetchFromGitHub, cmake, boost, botan, snappy, libopus, libuuid
, libXScrnSaver, openssl, qtbase, qtmultimedia }:

stdenv.mkDerivation {
  name = "firestr-0.8";

  src = fetchFromGitHub {
    owner  = "mempko";
    repo   = "firestr";
    rev    = "f888890f71d49953d05bccdd27a1c4f6690e165c";
    sha256 = "0s2kdi8rw3i3f8gbiy0ykyi6xj5n8p80m0d1i86mhh8jpagvbfzb";
  };

  buildInputs = [ cmake boost botan snappy libopus libuuid qtbase qtmultimedia
                  libXScrnSaver openssl ];

  patches = ./return.patch;

  postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace "set(Boost_USE_STATIC_LIBS on)" "" \
        --replace "/usr/include/botan" "${botan}/include/botan" \
        --replace "libopus.a"       "libopus.so" \
        --replace "libsnappy.a"     "libsnappy.so" \
        --replace "libbotan-1.10.a" "libbotan-1.10.so.0"
  '';

  meta = with stdenv.lib; {
    description = "Grass computing platform";
    homepage = http://firestr.com/;
    license = licenses.gpl3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
    broken = true;
  };
}

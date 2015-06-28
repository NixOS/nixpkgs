{ stdenv, fetchFromGitHub, cmake, x11, libX11, libXi, libXtst, libXrandr
, xinput, curl, cryptopp ? null, unzip }:

assert stdenv.isLinux -> cryptopp != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "synergy-${version}";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "synergy";
    repo = "synergy";
    rev = version;
    sha256 = "0n4zvz669vi2wyn6i6xhxp0j3nvjl4yzm441cqv6hb0d5k26wbcn";
  };

  patches = optional stdenv.isLinux ./cryptopp.patch;

  postPatch = (if stdenv.isLinux then ''
    sed -i -e '/HAVE_X11_EXTENSIONS_XRANDR_H/c \
      set(HAVE_X11_EXTENSIONS_XRANDR_H true)' CMakeLists.txt
  '' else ''
    ${unzip}/bin/unzip -d ext/cryptopp562 ext/cryptopp562.zip
  '') + ''
    ${unzip}/bin/unzip -d ext/gmock-1.6.0 ext/gmock-1.6.0.zip
    ${unzip}/bin/unzip -d ext/gtest-1.6.0 ext/gtest-1.6.0.zip
  '';

  buildInputs = [ cmake x11 libX11 libXi libXtst libXrandr xinput curl ]
             ++ optional stdenv.isLinux cryptopp;

  # At this moment make install doesn't work for synergy
  # http://synergy-foss.org/spit/issues/details/3317/

  installPhase = ''
    mkdir -p $out/bin
    cp ../bin/synergyc $out/bin
    cp ../bin/synergys $out/bin
    cp ../bin/synergyd $out/bin
  '';

  doCheck = true;
  checkPhase = "../bin/unittests";

  meta = {
    description = "Tool to share the mouse keyboard and the clipboard between computers";
    homepage = http://synergy-foss.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.aszlig ];
    platforms = platforms.all;
  };
}

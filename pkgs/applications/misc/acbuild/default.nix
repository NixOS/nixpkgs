{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "acbuild-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "appc";
    repo = "acbuild";
    rev = "v${version}";
    sha256 = "19f2fybz4m7d5sp1v8zkl26ig4dacr27qan9h5lxyn2v7a5z34rc";
  };

  buildInputs = [ go ];

  patchPhase = ''
    sed -i -e 's|\git describe --dirty|echo "${version}"|' build
  '';

  buildPhase = ''
    patchShebangs build
    ./build
  '';

  installPhase = ''
    mkdir -p $out
    mv bin $out
  '';

  meta = with stdenv.lib; {
    description = "A build tool for ACIs";
    homepage = https://github.com/appc/acbuild;
    license = licenses.asl20;
    maintainers = with maintainers; [ dgonyeo ];
    platforms = platforms.linux;
  };
}

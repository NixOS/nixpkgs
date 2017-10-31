{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "acbuild-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "appc";
    repo = "acbuild";
    rev = "v${version}";
    sha256 = "0s81xlaw75d05b4cidxml978hnxak8parwpnk9clanwqjbj66c7x";
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

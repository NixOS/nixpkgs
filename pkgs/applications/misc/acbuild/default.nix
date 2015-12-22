{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "acbuild-${version}";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "appc";
    repo = "acbuild";
    rev = "v${version}";
    sha256 = "0sajmjg655irwy5fywk88cmwhc1q186dg5w8589pab2jhwpavdx4";
  };

  buildInputs = [ go ];

  patchPhase = ''
    sed -i -e 's|\$(git describe --dirty)|"${version}"|' build
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

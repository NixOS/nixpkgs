{stdenv, fetchFromGitHub, cmake, boost, gmp, htslib, zlib, lzma, pkg-config}:

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "0.6.3-beta";

  src = fetchFromGitHub {
    owner = "luntergroup";
    repo = "octopus";
    rev = "v${version}";
    sha256 = "042fycg8ppld7iajpzq2d8h8wr0nw43zbl57y125sfihryvr373n";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost gmp htslib zlib lzma ];

  postInstall = ''
    mkdir $out/bin
    mv $out/octopus $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Bayesian haplotype-based mutation calling";
    license = licenses.mit;
    homepage = "https://github.com/luntergroup/octopus";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}

{stdenv, fetchFromGitHub, cmake, boost, gmp, htslib, zlib, lzma, pkg-config}:

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "luntergroup";
    repo = "octopus";
    rev = "v${version}";
    sha256 = "0y3g0xc3x3adbcmds6hh60023pfv1qrz6ak7jd88fg9vxi9bdrfb";
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

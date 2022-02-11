{lib, stdenv, fetchFromGitHub, cmake, boost, gmp, htslib, zlib, xz, pkg-config}:

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "luntergroup";
    repo = "octopus";
    rev = "v${version}";
    sha256 = "sha256-FAogksVxUlzMlC0BqRu22Vchj6VX+8yNlHRLyb3g1sE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost gmp htslib zlib xz ];

  postInstall = ''
    mkdir $out/bin
    mv $out/octopus $out/bin
  '';

  meta = with lib; {
    description = "Bayesian haplotype-based mutation calling";
    license = licenses.mit;
    homepage = "https://github.com/luntergroup/octopus";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}

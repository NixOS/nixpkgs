{lib, stdenv, fetchurl, fetchFromGitHub, cmake, boost179, gmp, htslib, zlib, xz, pkg-config}:

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
  buildInputs = [ boost179 gmp htslib zlib xz ];

  patches = [ (fetchurl {
    url = "https://github.com/luntergroup/octopus/commit/17a597d192bcd5192689bf38c5836a98b824867a.patch";
    sha256 = "sha256-VaUr63v7mzhh4VBghH7a7qrqOYwl6vucmmKzTi9yAjY=";
  }) ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
  ];

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

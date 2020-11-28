{ stdenv, fetchFromGitHub, cmake, gmp, coreutils }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "1c7f2x6hdamjkr50761gcb5mg8hhlc75k1mf18vn1k9zsy1gxlgz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];
  enableParallelBuilding = true;

  preConfigure = ''
    cd src
  '';

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace $out/bin/leanpkg \
      --replace "greadlink" "${coreutils}/bin/readlink"
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "https://leanprover.github.io/";
    changelog   = "https://github.com/leanprover-community/lean/blob/v${version}/doc/changes.md";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}


{ stdenv, fetchFromGitHub, cmake, gmp, coreutils }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "1dybq6104vc62x620izgblfd8dqc4ynaiw8ml07km78lq38anm6v";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];
  enableParallelBuilding = true;

  cmakeDir = "../src";

  # Running the tests is required to build the *.olean files for the core
  # library.
  doCheck = true;

  postPatch = "patchShebangs .";

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


{ lib, stdenv, fetchFromGitHub, cmake, gmp, coreutils }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.29.0";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "sha256-f2Gp76c+4R+ww52f1AyVZqixpei1WZPwr7pfgxMMb9Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];

  cmakeDir = "../src";

  # Running the tests is required to build the *.olean files for the core
  # library.
  doCheck = true;

  postPatch = "patchShebangs .";

  postInstall = lib.optionalString stdenv.isDarwin ''
    substituteInPlace $out/bin/leanpkg \
      --replace "greadlink" "${coreutils}/bin/readlink"
  '';

  meta = with lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "https://leanprover.github.io/";
    changelog   = "https://github.com/leanprover-community/lean/blob/v${version}/doc/changes.md";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}


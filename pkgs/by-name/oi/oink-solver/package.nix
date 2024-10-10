{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  lace,
  boost,
  build-extra-tools ? false,
  doCheck ? false, # The tests are very memory and computationally intensive
}:

stdenv.mkDerivation {
  pname = "oink";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "trolando";
    repo = "oink";
    rev = "257d0d088361204449c9bb204b457c2042e26cae";
    sha256 = "sha256-HpDyDQbng0GfALF0dRcdIAAf6VhG/yfVmQKQPuZx0C0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lace
    boost
  ];

  inherit doCheck;

  postInstall = lib.optionalString build-extra-tools ''
    install -m755 {nudge,dotty,verify,simple,rngame,stgame,counter_rr,counter_dp,counter_m,counter_core,counter_rob,counter_symsi,counter_ortl,counter_qpt,tc,tc+} $out/bin/
  '';

  cmakeFlags = [
    (lib.strings.cmakeBool "OINK_BUILD_EXTRA_TOOLS" build-extra-tools)
    (lib.strings.cmakeBool "OINK_BUILD_TESTS" doCheck)
  ];

  meta = with lib; {
    description = "An implementation of modern parity game solvers";
    homepage = "https://github.com/trolando/oink";
    maintainers = [ maintainers.mgttlinger ];
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "oink";
  };
}

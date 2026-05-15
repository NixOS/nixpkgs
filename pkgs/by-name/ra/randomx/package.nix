{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "randomX";
  version = "2.0.1";

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "tevador";
    repo = "randomX";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jyX4+4yXREcJMJLQ9fxThatIbolJzfnamNR0G+SR9oU=";
  };

  meta = {
    description = "Proof of work algorithm based on random code execution";
    homepage = "https://github.com/tevador/RandomX";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.unix;
  };

})

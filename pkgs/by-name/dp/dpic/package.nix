{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dpic";
  version = "2025.08.01";

  src = fetchurl {
    url = "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Dzj1wekVGIJsssbpViSzkNGAjvrcBAL4ORFRLwznJsM=";
  };

  # The prefix passed to configure is not used.
  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Implementation of the pic little language for creating drawings";
    homepage = "https://ece.uwaterloo.ca/~aplevich/dpic/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ aespinosa ];
    platforms = lib.platforms.all;
    mainProgram = "dpic";
  };
})

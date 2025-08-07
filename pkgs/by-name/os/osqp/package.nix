{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osqp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BOAytzJzHcggncQzeDrXwJOq8B3doWERJ6CKIVg1yJY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Quadratic programming solver using operator splitting";
    homepage = "https://osqp.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ taktoa ];
    platforms = lib.platforms.all;
  };
})

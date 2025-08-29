{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qdldl,
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

  postPatch = ''
    substituteInPlace algebra/_common/lin_sys/qdldl/qdldl.cmake --replace-fail \
      "GIT_REPOSITORY https://github.com/osqp/qdldl.git" \
      "URL ${qdldl.src}"
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ qdldl ];
  cmakeFlags = [ (lib.cmakeFeature "OSQP_VERSION" finalAttrs.version) ];

  meta = {
    description = "Quadratic programming solver using operator splitting";
    homepage = "https://osqp.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ taktoa ];
    platforms = lib.platforms.all;
  };
})

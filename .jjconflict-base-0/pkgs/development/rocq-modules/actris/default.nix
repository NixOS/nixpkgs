{
  lib,
  mkRocqDerivation,
  iris,
  version ? null,
}:

mkRocqDerivation {
  pname = "actris";
  # MPI's gitlab is unfortunately under siege of various LLM scrappers
  # and had to establish some strong rate limiting, a mirror is put on github
  # domain = "gitlab.mpi-sws.org";
  # owner = "iris";
  owner = "rocq-iris";
  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch iris.version [
      (case (isEq "4.5.0") "4.5.0")
    ] null;
  release."4.5.0".hash = "sha256-Kp3YDN2C2QNIDHfg9AJGfOjQ/9sM2MHRICO8iPgYdBw=";
  releaseRev = v: "actris-${v}";

  propagatedBuildInputs = [ iris ];

  meta = {
    description = "Framework for session protocol reasoning in Iris";
    homepage = "https://iris-project.org/actris";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chandradeepdey ];
  };
}

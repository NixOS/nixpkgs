{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "calceph";
  version = "5.0.0";
  src = fetchFromGitLab {
    domain = "gitlab.obspm.fr";
    owner = "imcce_calceph";
    repo = "calceph";
    tag = "calceph_${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-bSgHRVPo0M8SIlw5uqZ0nyt5cVyg3WmxcHistV1FugY=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    homepage = "https://www.imcce.fr/inpop/calceph/";
    changelog = "https://gitlab.obspm.fr/imcce_calceph/calceph/-/blob/${finalAttrs.src.rev}/NEWS";
    description = "C library for interacting with binary planetary ephemeris files, such INPOPxx, JPL DExxx and SPICE";
    license = with lib.licenses; [
      cecill21
      cecill-b
      cecill-c
    ];
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
  };
})

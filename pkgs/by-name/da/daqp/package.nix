{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "daqp";
  version = "0.9.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "darnstrom";
    repo = "daqp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ms+N/m33zqO0qgtQykOI++eCkDPf50qf8lbi+tO5ae0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
  ];

  cmakeFlags = [
    (lib.cmakeBool "EIGEN" true)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/darnstrom/daqp/releases/tag/${finalAttrs.src.tag}";
    description = "Dual active-set algorithm for convex quadratic programming";
    homepage = "https://github.com/darnstrom/daqp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nim65s
      renesat
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})

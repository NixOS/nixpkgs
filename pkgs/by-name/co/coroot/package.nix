{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  pkg-config,
  nodejs,
  npmHooks,
  lz4,
}:

buildGoModule (finalAttrs: {
  pname = "coroot";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rwj5dyAlAHDk7aimRDrUncwNTi4pCESxYmjSMPqweeI=";
  };

  vendorHash = "sha256-qKqfPRmp9hdlug9O90R5zRgslHOANcxGBoEzFipf7+w=";
  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/front";
    hash = "sha256-QFuEdsyQUmvFGXGBJyOd5UKJv7JEWQ24YM3BwTMUNGU=";
  };

  nativeBuildInputs = [
    pkg-config
    nodejs
    npmHooks.npmConfigHook
  ];
  buildInputs = [ lz4 ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  npmRoot = "front";
  preBuild = ''
    npm --prefix="$npmRoot" run build-prod
  '';

  # required for tests
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Open-source APM & Observability tool";
    homepage = "https://coroot.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot";
  };
})

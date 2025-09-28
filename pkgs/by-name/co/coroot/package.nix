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

buildGoModule rec {
  pname = "coroot";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${version}";
    hash = "sha256-EV/wpj8xQD0YDh9ztUJPRPvB2cVozQnuF7PZ8wwd1M4=";
  };

  vendorHash = "sha256-tLT2fCaljf96WyAu/gUS5wB8Et6daZhgFItEHSFhpOk=";
  npmDeps = fetchNpmDeps {
    src = "${src}/front";
    hash = "sha256-O63am2CUJtf9JPcfVrYV5JPRBYwa/yBYopWFfuOKShs=";
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

  meta = {
    description = "Open-source APM & Observability tool";
    homepage = "https://coroot.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot";
  };
}

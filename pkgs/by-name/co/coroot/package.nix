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
  version = "1.5.11";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${version}";
    hash = "sha256-lHzTKmD3HCwosvs1x6XxmRdiW/ENNGQiR0hzWzdU8EM=";
  };

  vendorHash = "sha256-YqZHhoaAgubI2+O2CTULXeQocLaz9WGpWRhETIzU7MU=";
  npmDeps = fetchNpmDeps {
    src = "${src}/front";
    hash = "sha256-inZV+iv837+7ntBae/oLSNLxpzoqEcJNPNdBE+osJHQ=";
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

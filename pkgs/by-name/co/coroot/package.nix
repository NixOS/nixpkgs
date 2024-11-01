{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,
  pkg-config,
  nodejs,
  npmHooks,
  lz4,
}:

buildGoModule rec {
  pname = "coroot";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${version}";
    hash = "sha256-z6eD+qAdwu7DoyKTlAQqucdWRtT+h4qCPt0eTQceYXw=";
  };
  # github.com/grafana/pyroscope-go/godeltaprof 0.1.6 is broken on go 1.23
  # use patch from https://github.com/coroot/coroot/pull/357 until it gets fixed
  patches = [
    (fetchpatch {
      url = "https://github.com/coroot/coroot/commit/9bf6ac0ad4dfaa7f13e6d9b5ce5e331d1478aafc.patch";
      hash = "sha256-5otqdYyQ57sNjF84CRgx0wcztsRdTdsNuhEkvGyw7UE=";
    })
  ];

  vendorHash = "sha256-W0UNw8FEIHDKQDCjBryDSJB/UhNyAtMxC6A/9lr79sg=";
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

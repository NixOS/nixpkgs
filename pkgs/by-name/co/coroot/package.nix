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
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot";
    rev = "v${version}";
    hash = "sha256-OvYjRcdXp0yqVPfkVyOSetl6oDKerQjOqr1z+9IIUgQ=";
  };

  vendorHash = "sha256-1Wi8iQeqqCVJnS7NkLyMqqzW9UbBSGw+TA5U2qq/OKc=";
  npmDeps = fetchNpmDeps {
    src = "${src}/front";
    hash = "sha256-Uk5lTZ6jmvb98wQhA8JHG5pwHDXiJ7h5ZWf4VeY2I+8=";
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
  };
}

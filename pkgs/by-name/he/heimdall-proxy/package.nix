{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.17.2";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-mSjxcf7Sbj6IVtO3ShVe/nrZgE+cJlx6JvOZ23WM7zQ=";
  };

  vendorHash = "sha256-3DOuDZh1rLuBaNnEJTDw/DXtEv8jhPk4kq2dvX4Scp0=";

  tags = [ "sqlite" ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/dadrus/heimdall/version.Version=${version}"
  ];

  meta = {
    description = "Cloud native Identity Aware Proxy and Access Control Decision service";
    homepage = "https://dadrus.github.io/heimdall";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ albertilagan ];
    mainProgram = "heimdall";
  };
}

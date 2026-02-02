{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gotrue-supabase,
}:

buildGoModule rec {
  pname = "auth";
  version = "2.185.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${version}";
    hash = "sha256-ZBu6/vXCqXRwMTKbIIYFl8ay7GpVEerzsJLNPBJL2nw=";
  };

  vendorHash = "sha256-fX1M+QP0pflJ0xV6VLQTS1Rn90Ac7GwVe6B5+A2KDvg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/supabase/auth/internal/utilities.Version=${version}"
  ];

  # integration tests require network to connect to postgres database
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gotrue-supabase;
    command = "auth version";
    inherit version;
  };

  meta = {
    homepage = "https://github.com/supabase/auth";
    description = "JWT based API for managing users and issuing JWT tokens";
    mainProgram = "auth";
    changelog = "https://github.com/supabase/auth/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

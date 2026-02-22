{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gotrue-supabase,
}:

buildGoModule (finalAttrs: {
  pname = "auth";
  version = "2.186.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "auth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8kB7gh5sp2D9dvyxsE/YMWoUx/jzAqw8nEBwB0XQlRQ=";
  };

  vendorHash = "sha256-QrqucIuYIhIMsD93+6HWf74LwVncOsbFB9gJR1GdMvA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/supabase/auth/internal/utilities.Version=${finalAttrs.version}"
  ];

  # integration tests require network to connect to postgres database
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = gotrue-supabase;
    command = "auth version";
    inherit (finalAttrs) version;
  };

  meta = {
    homepage = "https://github.com/supabase/auth";
    description = "JWT based API for managing users and issuing JWT tokens";
    mainProgram = "auth";
    changelog = "https://github.com/supabase/auth/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

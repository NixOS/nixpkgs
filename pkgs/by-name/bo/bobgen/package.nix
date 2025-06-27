{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bobgen";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pIw+fFnkkYJMYoftxSBwBZzJkhYBLjknOENDibVjJk4=";
  };

  vendorHash = "sha256-iVYzRKIUrjR/pzlpUMtgaFBn5idd/TBsSZxh/SQGT0M=";

  subPackages = [
    "gen/bobgen-sql"
    "gen/bobgen-psql"
    "gen/bobgen-mysql"
    "gen/bobgen-sqlite"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generates an ORM for Go based on a database schema";
    homepage = "https://github.com/stephenafamo/bob";
    changelog = "https://github.com/stephenafamo/bob/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      spotdemo4
    ];
    platforms = lib.platforms.all;
  };
})

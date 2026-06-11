{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bobgen";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dmZ9aOiVn0QEBvPwulvFEisZRw0PIid7NH22gD3Yzuc=";
  };

  vendorHash = "sha256-WzSUUgfWGz5XXq3iQrtpF91yOEr0QypTWq1rOJMntGQ=";

  subPackages = [
    "gen/bobgen-sql"
    "gen/bobgen-psql"
    "gen/bobgen-mysql"
    "gen/bobgen-sqlite"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SQL query builder and ORM/Factory generator for Go";
    homepage = "https://github.com/stephenafamo/bob";
    changelog = "https://github.com/stephenafamo/bob/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      spotdemo4
    ];
    platforms = lib.platforms.all;
  };
})

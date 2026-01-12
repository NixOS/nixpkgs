{
  lib,
  buildGoModule,
  fetchFromGitHub,
  postgresql,
}:
buildGoModule (finalAttrs: {
  pname = "pg-schema-diff";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = "pg-schema-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pAGd62P+w8BnGMQp2kzAg/mLPvJG6ma25K/JmjpivLk=";
  };

  nativeCheckInputs = [
    postgresql
  ];

  vendorHash = "sha256-9tronDAe3/5bBtiMW04YGSgxww/F7xlq84sjYFTfxnk=";

  meta = {
    description = "Go library for diffing Postgres schemas and generating SQL migrations";
    homepage = "https://github.com/stripe/pg-schema-diff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bitbloxhub ];
    mainProgram = "pg-schema-diff";
  };
})

{
  fetchFromGitHub,

  surrealdb,
}:
(surrealdb.override { backend = "surrealkv"; }).overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "4.0.0";
    src = fetchFromGitHub {
      inherit (previousAttrs.src) owner repo;
      tag = "v${finalAttrs.version}";
      hash = "sha256-oUgFCU/k7Eynpw9jT4+9yOp3SKuTZ3zcoCpicq9id9A=";
    };
    cargoHash = "sha256-B1Sp4r9QCij6l9aBx56lItaraou5IQNgH1nTfawOZ1c=";
  }
)

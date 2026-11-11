{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  stdenv,
}:

buildGo127Module (
  finalAttrs:
  let
    cmdPackage = "github.com/rqlite/rqlite/v${lib.versions.major finalAttrs.version}/cmd";
  in
  {
    pname = "rqlite";
    version = "10.6.5";

    src = fetchFromGitHub {
      owner = "rqlite";
      repo = "rqlite";
      tag = "v${finalAttrs.version}";
      hash = "sha256-9/ACNtwsO0hk3dF1CHU/hfvFtxbxMcmZU2Zlr5kz3nA=";
    };

    vendorHash = "sha256-iMtBR9pN1Qls9Hyebf2oH2PP3LulBzhSiL/fVG2bYFE=";

    subPackages = [
      "cmd/rqlite"
      "cmd/rqlited"
      "cmd/rqbench"
    ];

    # Mirror the upstream release build metadata
    ldflags = [
      "-s"
      "-X ${cmdPackage}.CompilerCommand=${stdenv.cc.targetPrefix}cc"
      "-X ${cmdPackage}.Version=${finalAttrs.version}"
      "-X ${cmdPackage}.Branch=${finalAttrs.src.tag}"
      "-X ${cmdPackage}.Commit=${finalAttrs.src.tag}"
      "-X ${cmdPackage}.Buildtime=1970-01-01T00:00:00Z"
    ];

    doCheck = true;

    meta = {
      description = "Lightweight, fault-tolerant, distributed relational database built on SQLite";
      homepage = "https://github.com/rqlite/rqlite";
      changelog = "https://github.com/rqlite/rqlite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
      license = lib.licenses.mit;
      mainProgram = "rqlite";
      maintainers = with lib.maintainers; [ iamanaws ];
    };
  }
)

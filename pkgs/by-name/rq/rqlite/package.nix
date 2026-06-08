{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (
  finalAttrs:
  let
    cmdPackage = "github.com/rqlite/rqlite/v${lib.versions.major finalAttrs.version}/cmd";
  in
  {
    pname = "rqlite";
    version = "10.2.0";

    src = fetchFromGitHub {
      owner = "rqlite";
      repo = "rqlite";
      tag = "v${finalAttrs.version}";
      hash = "sha256-XpdI3OFkMHlnUQ6LXo/NDagRwaRkQMq2UmFg4MOKNJ4=";
    };

    vendorHash = "sha256-7f9A9BnENKF7kRftB/ii1EQeHMsYp9ZSb5T474ngs6E=";

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

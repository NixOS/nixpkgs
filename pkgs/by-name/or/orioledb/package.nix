{
  buildPostgresql,
  fetchFromGitHub,
  lib,
}:

let
  orioledb-postgres = buildPostgresql rec {
    pname = "orioledb-postgres";
    version = "17.18";

    src = fetchFromGitHub {
      owner = "orioledb";
      repo = "postgres";
      tag = "patches17_18";
      hash = "sha256-GlegSFtRrKIF+gueFWQiZZlCQJmo8Ols13yJzois0Vw=";
    };

    # Configure extracts the patch version from the git tag. This
    # is required by the extension build to verify it builds against
    # the correctly patched postgresql version.
    postPatch = ''
      substituteInPlace configure \
        --replace-fail "git describe --tags --exact-match" "echo '${src.tag}'"
    '';

    # orioledb seems to have made pg_rewind extensible somehow. For that reason,
    # there is now a header file in the -dev output for it. Until reported otherwise
    # we'll just strip that reference to avoid a cycle between outputs.
    postInstall = ''
      remove-references-to -t "$dev"  -t "$doc" -t "$man" "$out/bin/pg_rewind"
    '';

    meta = {
      description = "Cloud-native storage engine for PostgreSQL";
      maintainers = [
        lib.maintainers.wolfgangwalther
      ];
    };
  };
in
orioledb-postgres.withPackages (pkgs: [ (pkgs.callPackage ./extension.nix { }) ])

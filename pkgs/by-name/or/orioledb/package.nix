{
  fetchFromGitHub,
  lib,
  postgresql_18,
}:

let
  orioledb-postgres = postgresql_18.overrideAttrs (
    finalAttrs: oldAttrs: {
      pname = "orioledb-postgres";
      version = "18.1";

      src = fetchFromGitHub {
        owner = "orioledb";
        repo = "postgres";
        tag = "patches18_1";
        hash = "sha256-TCpmTa9R+a+rrTRSNkfhBDaVto1RtKf1R+qnepw9bV0=";
      };

      # Configure extracts the patch version from the git tag. This
      # is required by the extension build to verify it builds against
      # the correctly patched postgresql version.
      postPatch = oldAttrs.postPatch or "" + ''
        substituteInPlace configure \
          --replace-fail "git describe --tags --exact-match" "echo '${finalAttrs.src.tag}'"
      '';

      # orioledb seems to have made pg_rewind extensible somehow. For that reason,
      # there is now a header file in the -dev output for it. Until reported otherwise
      # we'll just strip that reference to avoid a cycle between outputs.
      postInstall = oldAttrs.postInstall or "" + ''
        remove-references-to -t "$dev"  -t "$doc" -t "$man" "$out/bin/pg_rewind"
      '';

      meta = {
        inherit (oldAttrs.meta)
          license
          pkgConfigModules
          platforms
          broken
          ;
        description = "Cloud-native storage engine for PostgreSQL";
        maintainers = [
          lib.maintainers.wolfgangwalther
        ];
      };
    }
  );
in
orioledb-postgres.withPackages (pkgs: [ (pkgs.callPackage ./extension.nix { }) ])

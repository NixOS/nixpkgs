# to run these tests (and the others)
# nix-build nixpkgs/lib/tests/release.nix
{ # The pkgs used for dependencies for the testing itself
  pkgs
, lib
}:

let
  inherit (lib) types;

  maintainerModule = { config, ... }: {
    options = {
      name = lib.mkOption {
        type = types.str;
      };
      email = lib.mkOption {
        type = types.str;
      };
      github = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      githubId = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
      };
      keys = lib.mkOption {
        type = types.listOf (types.submodule {
          options.longkeyid = lib.mkOption { type = types.str; };
          options.fingerprint = lib.mkOption { type = types.str; };
        });
        default = [];
      };
    };
  };

  checkMaintainer = handle: uncheckedAttrs:
  let
      prefix = [ "lib" "maintainers" handle ];
      checkedAttrs = (lib.modules.evalModules {
        inherit prefix;
        modules = [
          maintainerModule
          {
            _file = toString ../../maintainers/maintainer-list.nix;
            config = uncheckedAttrs;
          }
        ];
      }).config;

      checkGithubId = lib.optional (checkedAttrs.github != null && checkedAttrs.githubId == null) ''
        echo ${lib.escapeShellArg (lib.showOption prefix)}': If `github` is specified, `githubId` must be too.'
        # Calling this too often would hit non-authenticated API limits, but this
        # shouldn't happen since such errors will get fixed rather quickly
        info=$(curl -sS https://api.github.com/users/${checkedAttrs.github})
        id=$(jq -r '.id' <<< "$info")
        echo "The GitHub ID for GitHub user ${checkedAttrs.github} is $id:"
        echo -e "    githubId = $id;\n"
      '';
    in lib.deepSeq checkedAttrs checkGithubId;

  missingGithubIds = lib.concatLists (lib.mapAttrsToList checkMaintainer lib.maintainers);

  success = pkgs.runCommandNoCC "checked-maintainers-success" {} ">$out";

  failure = pkgs.runCommandNoCC "checked-maintainers-failure" {
    nativeBuildInputs = [ pkgs.curl pkgs.jq ];
    outputHash = "sha256:${lib.fakeSha256}";
    outputHAlgo = "sha256";
    outputHashMode = "flat";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  } ''
    ${lib.concatStringsSep "\n" missingGithubIds}
    exit 1
  '';
in if missingGithubIds == [] then success else failure

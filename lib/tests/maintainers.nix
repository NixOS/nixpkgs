# to run these tests (and the others)
# nix-build nixpkgs/lib/tests/release.nix
{ # The pkgs used for dependencies for the testing itself
  pkgs ? import ../.. {}
, lib ? pkgs.lib
}:

let
  checkMaintainer = handle: uncheckedAttrs:
  let
      prefix = [ "lib" "maintainers" handle ];
      checkedAttrs = (lib.modules.evalModules {
        inherit prefix;
        modules = [
          ./maintainer-module.nix
          {
            _file = toString ../../maintainers/maintainer-list.nix;
            config = uncheckedAttrs;
          }
        ];
      }).config;

      checks = lib.optional (checkedAttrs.github != null && checkedAttrs.githubId == null) ''
        echo ${lib.escapeShellArg (lib.showOption prefix)}': If `github` is specified, `githubId` must be too.'
        # Calling this too often would hit non-authenticated API limits, but this
        # shouldn't happen since such errors will get fixed rather quickly
        info=$(curl -sS https://api.github.com/users/${checkedAttrs.github})
        id=$(jq -r '.id' <<< "$info")
        echo "The GitHub ID for GitHub user ${checkedAttrs.github} is $id:"
        echo -e "    githubId = $id;\n"
      '' ++ lib.optional (checkedAttrs.email == null && checkedAttrs.github == null && checkedAttrs.matrix == null) ''
        echo ${lib.escapeShellArg (lib.showOption prefix)}': At least one of `email`, `github` or `matrix` must be specified, so that users know how to reach you.'
      '';
    in lib.deepSeq checkedAttrs checks;

  missingGithubIds = lib.concatLists (lib.mapAttrsToList checkMaintainer lib.maintainers);

  success = pkgs.runCommand "checked-maintainers-success" {} ">$out";

  failure = pkgs.runCommand "checked-maintainers-failure" {
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

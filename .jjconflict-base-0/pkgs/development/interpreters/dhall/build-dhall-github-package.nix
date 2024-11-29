{ buildDhallPackage, fetchFromGitHub, lib }:

# This function is used by `dhall-to-nixpkgs` when given a GitHub repository
lib.makePackageOverridable
  ( { # Arguments passed through to `buildDhallPackage`
      name
    , dependencies ? []
    , source ? false

    , # The directory containing the Dhall files, if other than the root of the
      # repository
      directory ? ""
    , # The file to import, relative to the above directory
      file ? "package.dhall"
      # Set to `true` to generate documentation for the package
    , document ? false

      # Arguments passed through to `fetchFromGitHub`
    , owner
    , repo
    , rev
      # Extra arguments passed through to `fetchFromGitHub`, such as the hash
      # or `fetchSubmodules`
    , ...
    }@args:

    let
      versionedName = "${name}-${rev}";

      src = fetchFromGitHub ({
        name = "${versionedName}-source";

        inherit owner repo rev;
      } // removeAttrs args [
        "name"
        "dependencies"
        "document"
        "source"
        "directory"
        "file"
        "owner"
        "repo"
        "rev"
      ]);

      prefix = lib.optionalString (directory != "") "/${directory}";

    in
      buildDhallPackage
        ( { inherit dependencies source;

            name = versionedName;

            code = "${src}${prefix}/${file}";
          }
        // lib.optionalAttrs document
          { documentationRoot = "${src}/${prefix}";

            baseImportUrl = "https://raw.githubusercontent.com/${owner}/${repo}/${rev}${prefix}";
          }
        )
  )

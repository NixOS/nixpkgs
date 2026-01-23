{ lib, fetchFromGitea }:
# fetchFromGitea, but domain is set to 'codeberg.org'.
lib.makeOverridable ({ ... }@args: fetchFromGitea ({ domain = "codeberg.org"; } // args))

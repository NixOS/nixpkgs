{ lib, fetchFromGitea }:
lib.makeOverridable (args: fetchFromGitea ({ domain = "codeberg.org"; } // args))

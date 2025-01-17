# Gitea's URLs are compatible with GitHub

{ lib, fetchFromGitHub }:

lib.makeOverridable (
  { domain, ... }@args:

  fetchFromGitHub ((removeAttrs args [ "domain" ]) // { githubBase = domain; })
)

# Gitea's URLs are compatible with GitHub

{ lib, fetchFromGitHub }:

{ domain, ... }@args:

fetchFromGitHub ((removeAttrs args [ "domain" ]) // { githubBase = domain; })

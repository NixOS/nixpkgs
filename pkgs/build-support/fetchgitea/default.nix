# Gitea's URLs are compatible with GitHub

{ lib, fetchFromGitHub }:

lib.makeOverridable (
  {
    domain,
    functionName ? "fetchFromGitea",
    ...
  }@args:

  fetchFromGitHub (
    (removeAttrs args [
      "domain"
      "functionName"
    ])
    // {
      inherit functionName;
      githubBase = domain;
    }
  )
)

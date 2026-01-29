{ testers, fetchBunDeps, ... }:

{
  #simple = testers.invalidateFetcherByDrvHash fetchBunDeps {
  #  bunLock = ./simple.lock;
  #  sha256 = "sha256-TifOgq9sGMm2nv6ww6126h1Hmae5sceZmCZQmNbVj8Q=";
  #};

  #gitDep = testers.invalidateFetcherByDrvHash fetchBunDeps {
  #  bunLock = ./git.lock;
  #  sha256 = "sha256-IgbRVP6XJc8ibIq7SskZq+Th43GI9+WP5dSpPDN3c5s=";
  #};

  #githubDep = testers.invalidateFetcherByDrvHash fetchBunDeps {
  #  bunLock = ./github.lock;
  #  sha256 = "sha256-ooF9GB94UgVru6ZUqsf867lUUqRVGs9W7o7ndZf2Hxs=";
  #};

  #githubReleaseDep = testers.invalidateFetcherByDrvHash fetchBunDeps {
  #  bunLock = ./github-release.lock;
  #  sha256 = "sha256-c1AXXRflkQpfp3sn1tSMVbMnbV/v2Ano9ligNwbItdY=";
  #};

  #workspaceDep = testers.invalidateFetcherByDrvHash fetchBunDeps {
  #  bunLock = ./workspace.lock;
  #  sha256 = "sha256-ms1uI7qBt0GgI7wlXR4nJ+bPdKSSctOEgBzm59WkiVo=";
  #};

  #complexDep = testers.invalidateFetcherByDrvHash fetchBunDeps {
  #  bunLock = ./complex.lock;
  #  sha256 = "sha256-BbqqdXnrebOurDhcz4pnPtRuSH1QAA6emRoJEpy4DlY=";
  #};

  bunInitDep = testers.invalidateFetcherByDrvHash fetchBunDeps {
    bunLock = ./bun-init.lock;
    sha256 = "sha256-4b/LOiAt+pQ6rKf7zNOyCB0/TDXfdw91LAqi985ZzjQ=";
  };
}

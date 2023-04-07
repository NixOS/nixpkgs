{ fetchgit }: args@{ name, ... }:


fetchgit (args // {
  leaveDotGit = true;
})

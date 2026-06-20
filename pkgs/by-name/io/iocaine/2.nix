{
  callPackage,
  fetchFromGitea,
  ...
}:
callPackage ./generic.nix {
  version = "2.5.1";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-2.5.1";
    hash = "sha256-213QLpGBKSsT9r8O27PyMom5+OGPz0VtRBevxswISZA=";
  };

  cargoHash = "sha256-EgPGDlJX/m+v3f/tGIO+saGHoYrtiWLZuMlXEvsgnxE=";
}

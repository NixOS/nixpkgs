import ./generic.nix {
  version = "15.0.6";
  hash = "sha256-kWmBs/qAiBlmVcSwBM+rXapDbC8IpJtKfQRVPLH4geI=";
  npmDepsHash = "sha256-wPta+potJJeOac7TyMk3BZg6su6mgHCEgesrsr7SCR4=";
  vendorHash = "sha256-Kx+mP3GKfEOlsy5bkF7QYDebkrV+FHr37aQC4th/XJM=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}

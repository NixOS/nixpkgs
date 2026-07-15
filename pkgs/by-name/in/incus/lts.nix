import ./generic.nix {
  hash = "sha256-Ivj0vWKuhgb4VvyxcuB+CXsJ02zwo65rqxD5/cLUmSk=";
  version = "7.0.1";
  vendorHash = "sha256-F3LhWVjckU0ypgOppHztjR6hDB6enHxoDmRWcSDfwQE=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(7\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}

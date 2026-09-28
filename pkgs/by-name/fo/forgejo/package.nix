import ./generic.nix {
  version = "16.0.5";
  hash = "sha256-Ci6QuRNZ4miUzqPz5/YPQgo/wbndN3vFsBigApW8XOY=";
  npmDepsHash = "sha256-CMShFS5JOqVwjLf1VKRaRD04GLuL4kRti27pVe4Pe2k=";
  vendorHash = "sha256-yI74OphRoUvnsQ9qfnQdpUg2Jj4j72zVzP/Jr10XUWM=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}

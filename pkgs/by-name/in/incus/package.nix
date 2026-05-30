import ./generic.nix {
  hash = "sha256-g0YnvPMwk7WpYCl5VbRtHKVYoLlrk6QYhRaRRqulVQM=";
  version = "7.1.0";
  vendorHash = "sha256-VqvDrjdBTblqEOY/HtoKXGRAdoTJpSWxkmgJNNPw6eQ=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}

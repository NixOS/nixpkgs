import ./generic.nix {
  hash = "sha256-g0YnvPMwk7WpYCl5VbRtHKVYoLlrk6QYhRaRRqulVQM=";
  version = "7.1.0";
  vendorHash = "sha256-VqvDrjdBTblqEOY/HtoKXGRAdoTJpSWxkmgJNNPw6eQ=";
  patches = fetchpatch2: [
    (fetchpatch2 {
      name = "lxc-fix-environment-quoting.patch";
      url = "https://github.com/lxc/incus/commit/a1276cdb57297245496ac8c1db76b90d1fcebd3b.patch?full_index=1";
      hash = "sha256-NqEMYcDYx18KbqShKxmaK1o08c8/X4O87zXclQ36Ors=";
    })
  ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}

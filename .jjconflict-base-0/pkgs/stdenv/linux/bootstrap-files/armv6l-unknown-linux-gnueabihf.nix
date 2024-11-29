{
  # Note: do not use Hydra as a source URL. Ask a member of the
  # infrastructure team to mirror the job.
  busybox = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv6l.dist/latest
    # from build: https://hydra.nixos.org/build/114202834
    url = "http://tarballs.nixos.org/stdenv-linux/armv6l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/busybox";
    # note: the following hash is different than the above hash, due to executable = true
    sha256 = "1q02537cq56wlaxbz3s3kj5vmh6jbm27jhvga6b4m4jycz5sxxp6";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    # from job: https://hydra.nixos.org/job/nixpkgs/cross-trunk/bootstrapTools.armv6l.dist/latest
    # from build: https://hydra.nixos.org/build/114202834
    url = "http://tarballs.nixos.org/stdenv-linux/armv6l/0eb0ddc4dbe3cd5415c6b6e657538eb809fc3778/bootstrap-tools.tar.xz";
    sha256 = "0810fe74f8cd09831f177d075bd451a66b71278d3cc8db55b07c5e38ef3fbf3f";
  };
}

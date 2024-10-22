let self = {
  "14.12" = "gs://nixos-cloud-images/nixos-14.12.471.1f09b77-x86_64-linux.raw.tar.gz";
  "15.09" = "gs://nixos-cloud-images/nixos-15.09.425.7870f20-x86_64-linux.raw.tar.gz";
  "16.03" = "gs://nixos-cloud-images/nixos-image-16.03.847.8688c17-x86_64-linux.raw.tar.gz";
  "17.03" = "gs://nixos-cloud-images/nixos-image-17.03.1082.4aab5c5798-x86_64-linux.raw.tar.gz";
  "18.03" = "gs://nixos-cloud-images/nixos-image-18.03.132536.fdb5ba4cdf9-x86_64-linux.raw.tar.gz";
  "18.09" = "gs://nixos-cloud-images/nixos-image-18.09.1228.a4c4cbb613c-x86_64-linux.raw.tar.gz";

  # This format will be handled by the upcoming NixOPS 2.0 release.
  # The old images based on a GS object are deprecated.
  "20.09" = {
    project = "nixos-cloud";
    name = "nixos-image-20-09-3531-3858fbc08e6-x86-64-linux";
  };

  latest = self."20.09";
}; in self

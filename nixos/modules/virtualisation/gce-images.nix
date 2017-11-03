let self = {
  "14.12" = "gs://nixos-cloud-images/nixos-14.12.471.1f09b77-x86_64-linux.raw.tar.gz";
  "15.09" = "gs://nixos-cloud-images/nixos-15.09.425.7870f20-x86_64-linux.raw.tar.gz";
  "16.03" = "gs://nixos-cloud-images/nixos-image-16.03.847.8688c17-x86_64-linux.raw.tar.gz";
  "17.03" = "gs://nixos-cloud-images/nixos-image-17.03.1082.4aab5c5798-x86_64-linux.raw.tar.gz";

  latest = self."17.03";
}; in self

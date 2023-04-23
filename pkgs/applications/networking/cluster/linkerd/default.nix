{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.13.1";
  sha256 = "1qsf2d4haqs93qf88f2vvjsgm5a5gnmivkdpdbvpwy0q8bd8rfnj";
  vendorSha256 = "sha256-6KuXEKuQJvRNUM+6Uo+J9D3eHI+1tt62C5XZsEDwkTc=";
}

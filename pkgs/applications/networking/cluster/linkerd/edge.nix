{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.7.1";
  sha256 = "1lvangia0hllnlccxv0f9mlp3ym8l54wmqihicd44p9nyxbwbx3d";
  vendorSha256 = "sha256-1ir+IjyT9P+D3AbPo/7wWyZRFiKqZLJ/hoFUM1jtM0A=";
}

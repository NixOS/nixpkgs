{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.6.3";
  sha256 = "0h1pwfqf6y3cfhyx1srrr0dv25d5fxk10qfqzx0hl64h2dp6srr6";
  vendorSha256 = "sha256-1ir+IjyT9P+D3AbPo/7wWyZRFiKqZLJ/hoFUM1jtM0A=";
}

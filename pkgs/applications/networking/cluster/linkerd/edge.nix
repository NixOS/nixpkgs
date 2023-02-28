{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.2.3";
  sha256 = "0lqbsh3237hh1rifi7w3h1mq4m6cnpxvb1h3dxghv5sblyivqfz9";
  vendorSha256 = "sha256-gZ9t10Lj0wXeVBfmxKax9FYrcNL+ZEJOqhQfYw9Qwzw=";
}

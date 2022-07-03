{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.2.8";
  sha256 = "11yn8g9wsdb35q97wn5vy93kgbn5462k0a33wxlfdz14i5h00yj8";
  vendorSha256 = "06wyfnlm37qjvd1pwzygflfpcp9p52f61wgi6pb9l7hnqy2ph6j5";
}

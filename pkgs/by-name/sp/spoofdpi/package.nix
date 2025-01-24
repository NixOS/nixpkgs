{
  lib,
  fetchFromGitHub,
  buildGoModule,
  ...
}:

buildGoModule rec {
  pname = "SpoofDPI";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${version}";
    hash = "sha256-m4fhFhZLuWT1diDlDTmTsNrckKTjhEZbhciv44FZcro=";
  };

  vendorHash = "sha256-47Gt5SI6VXq4+1T0LxFvQoYNk+JqTt3DonDXLfmFBzw=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
}

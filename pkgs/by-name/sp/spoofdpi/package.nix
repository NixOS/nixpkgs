{ lib, stdenv, fetchFromGitHub, buildGoModule, ... }:

buildGoModule rec {
  pname = "SpoofDPI";
  version = "0.10.12";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "${pname}";
    rev = "${version}";
    hash = "sha256-BNOfhCBuvro9nD9y6NLklTSmhYk5gFOOaDn+58a7SLs=";
  };

  vendorHash = "sha256-47Gt5SI6VXq4+1T0LxFvQoYNk+JqTt3DonDXLfmFBzw=";

  meta = with lib; {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "A simple and fast anti-censorship tool written in Go";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ s0me1newithhand7s ];
  };
}

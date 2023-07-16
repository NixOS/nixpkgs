{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pat";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "la5nta";
    repo = "pat";
    rev = "v${version}";
    hash = "sha256-ydv7RQ6MJ+ifWr+babdsDRnaS7DSAU+jiFJkQszy/Ro=";
  };

  vendorHash = "sha256-TMi5l9qzhhtdJKMkKdy7kiEJJ5UPPJLkfholl+dm/78=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Pat is a cross platform Winlink client written in Go.";
    homepage = "https://getpat.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ dotemup ];
  };
}

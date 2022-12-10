{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = "${version}";
    sha256 = "sha256-UGrIj/0ysU4i6PQVkuIeyGdKNCMa9LxikaIPhSKGvaQ=";
  };

  vendorSha256 = "sha256-AiRbUSgMoU8nTzis/7H9HRW2/xZxXFf39JipRbukeiA=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}

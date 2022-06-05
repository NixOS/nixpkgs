{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = "${version}";
    sha256 = "sha256-CQVHU3gIIiucrz9TA2ltPNmj6d22vbraktBoyTHTQ1k=";
  };

  patches = [
    # fix inconsistent vendoring
    # https://github.com/getAlby/lndhub.go/pull/184
    (fetchpatch {
      url = "https://github.com/getAlby/lndhub.go/commit/2ee7ace9385f8626eb15cbf653ccd46423b5a9c5.patch";
      sha256 = "sha256-1ESPlCTzpFbqshzS6xF4apY8Doz9GvEbZe93Z93P9EI=";
    })
  ];

  vendorSha256 = "sha256-bp5q8K7OpvNo28jojaPPj53hUe+me4oLwDBkgZk+0Ec=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}

{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = "${version}";
    sha256 = "sha256-n/mbTd2gc6+R2prt67uHKxFyFXoFaJ/T+cB7pbVYR+0=";
  };

  patches = [
    # fix inconsistent vendoring
    # https://github.com/getAlby/lndhub.go/pull/190
    (fetchpatch {
      url = "https://github.com/getAlby/lndhub.go/commit/3bf7149b3b45c4c4a979effee7e166b304342765.patch";
      sha256 = "sha256-fplDqEv+P3KKs6rSvw04sOp3bBnwuyDWSonKyyDWvlM=";
    })
  ];

  vendorSha256 = "sha256-KD2/H0nG6Lg590mdaZ8Zm4+ggZcw6yKrITEJLk4BWAU=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}

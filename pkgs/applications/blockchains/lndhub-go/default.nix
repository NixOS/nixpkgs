{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "lndhub-go";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "lndhub.go";
    rev = "${version}";
    sha256 = "sha256-QtLSI5xjXevTTr85Zsylabhay52ul8jFq1j6WzgSLcs=";
  };

  vendorSha256 = "sha256-12RTaXStvx29JjE1u3AjBTrPf6gKfLHJHMJpbQysEew=";

  doCheck = false; # tests require networking

  meta = with lib; {
    description = "Accounting wrapper for the Lightning Network";
    homepage = "https://github.com/getAlby/lndhub.go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
  };
}

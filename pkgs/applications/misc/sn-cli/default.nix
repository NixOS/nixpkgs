{ lib, fetchFromGitHub, buildGoModule, installShellFiles, stdenv, testers, gh }:

buildGoModule rec {
  pname = "sn-cli";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "jonhadfield";
    repo = "sn-cli";
    rev = "${version}";
    hash = "sha256-KU1EW/yJ+Ff8Cwv1GnFlRv7AyRLZ4/3tqNUQDJL/peo=";
  };

  vendorHash = "sha256-mTgh11XjsAedFXJVAP7iaDt1XaGaNYPaozlsN4DNtek=";

  nativeBuildInputs = [ installShellFiles ];

  # requires a server instance to work against
  doCheck = false;

  meta = with lib; {
    description = "A command line interface for standard notes";
    homepage = "https://github.com/jonhadfield/sn-cli";
    license = licenses.agpl3;
    maintainers = with maintainers; [ s1341 ];
  };
}

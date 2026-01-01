{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-dnscollector";
<<<<<<< HEAD
  version = "1.14.0";
=======
  version = "1.13.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-J6h/td5vCZwVruamZziIxRhAOdLdlv3Aupz9m0bExU4=";
  };

  vendorHash = "sha256-BQLlEY9CJDwJRbzB5kflBwwxcWMLbaqgWUtz2p3CJsE=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
=======
    rev = "v${version}";
    sha256 = "sha256-oip7rMCcWppUwCPy6VG/kJsNWf1EZZmf0iTj8FSvHeE=";
  };

  vendorHash = "sha256-1gFsLsPrsJhZ6V3/H22ZjIHrG1hTsRCj/Ur3gC01NSE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    license = licenses.mit;
    maintainers = with maintainers; [ shift ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

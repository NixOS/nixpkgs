{ lib

, buildGoModule
, fetchFromGitHub
, sqlite
}:

buildGoModule rec {
  pname = "expenses";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "expenses";
    rev = "v${version}";
    sha256 = "sha256-CaIbLtP7ziv9UBQE+QsNnqX65OV+6GIvkLwKm1G++iY=";
  };

  vendorSha256 = "sha256-NWTFxF4QCH1q1xx+hmVmpvDeOlqH5Ai2+0ParE5px9M=";

  # package does not contain any tests as of v0.2.2
  doCheck = false;

  buildInputs = [ sqlite ];

  ldflags = [
    "-s" "-w" "-X github.com/manojkarthick/expenses/cmd.Version=${version}"
  ];

  meta = with lib; {
   description = "An interactive command line expense logger";
   license = licenses.mit;
   maintainers = [ maintainers.manojkarthick ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "firectl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3MNNgFRq4goWdHFyqWNMAl2K0eKfd03BF05i82FIzNE=";
  };

  vendorHash = "sha256-rD+QCQKgCZU5ktItV8NYqoyQPR7lk8sutvJwSJxFfZQ=";

  doCheck = false;

  meta = with lib; {
    description = "A command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}

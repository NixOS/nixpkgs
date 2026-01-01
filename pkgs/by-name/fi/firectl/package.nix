{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "firectl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = "firectl";
    rev = "v${version}";
    hash = "sha256-3MNNgFRq4goWdHFyqWNMAl2K0eKfd03BF05i82FIzNE=";
  };

  vendorHash = "sha256-rD+QCQKgCZU5ktItV8NYqoyQPR7lk8sutvJwSJxFfZQ=";

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ xrelkd ];
=======
  meta = with lib; {
    description = "Command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "firectl";
  };
}

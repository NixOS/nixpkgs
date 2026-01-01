{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GoSH";
    tag = "v${version}";
    hash = "sha256-h4WqaN2okAeaU/+0fs8zLYDtyQLuLkCDdGrkGz8rdhg=";
  };

  vendorHash = "sha256-ITz6nkhttG6bsIZLsp03rcbEBHUQ7pFl4H6FOHTXIU4=";

  subPackages = [ "." ];

<<<<<<< HEAD
  meta = {
    description = "Reverse/bind shell generator";
    homepage = "https://github.com/redcode-labs/GoSH";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    teams = [ lib.teams.redcodelabs ];
=======
  meta = with lib; {
    description = "Reverse/bind shell generator";
    homepage = "https://github.com/redcode-labs/GoSH";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    teams = [ teams.redcodelabs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "GoSH";
  };
}

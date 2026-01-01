{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "api-linter";
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oaSWp1FmanCWMRYk3Dm1WZ+MnxooXqT9rom25JeFrTg=";
  };

  vendorHash = "sha256-X5/UH8dX89nTPlYMbVuyG82WrDmU/dP7LiZfMoN6c4A=";
=======
    hash = "sha256-psyv/J1/7H8s34qqZD4s7Ls1mn2lht5VbNxZrXPC0iw=";
  };

  vendorHash = "sha256-IpL9RIhO9ivXKHczca4m6R6jmcNEn5KXqNxWmtU30qE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xrelkd ];
=======
  meta = with lib; {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "api-linter";
  };
}

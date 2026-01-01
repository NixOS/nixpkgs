{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "age-plugin-sss";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-sss";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QNu2Sp0CxYYXuMzf7X0mMYI677ICu5emOM4F9HlKhHA=";
  };

  vendorHash = "sha256-Aw7dwro6adluhQXPlZ9RZVGBAmNw539Z3c+a8TmPTXU=";
=======
    hash = "sha256-ZcL1bty4qMWVl8zif9tAWFKZiTFklHxaAHESpapZ4WM=";
  };

  vendorHash = "sha256-Sr+6Tgbm7n8gQMqZng3kyzmpMgBZaIX1oEn6nV5c89U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = {
    description = "Age plugin to split keys and wrap them with different recipients using Shamir's Secret Sharing";
    homepage = "https://github.com/olastor/age-plugin-sss/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "age-plugin-sss";
  };
}

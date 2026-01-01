{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gat";
<<<<<<< HEAD
  version = "0.26.0";
=======
  version = "0.25.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "gat";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aWGSn5eeFTfBrAsYj38jcf6Xsrz0X5crjjOe0fNu1Mo=";
  };

  vendorHash = "sha256-C1Nm4czf6F2u/OU4jdRQLTXWKBo3mF0TqypbF1pO8yc=";
=======
    hash = "sha256-NE/m5fp+iJDlz3AtkjIAlO4CB7CVLeWzXYY5xCYX+cI=";
  };

  vendorHash = "sha256-TZz7aAKMld7KFbW+vcysgSO+Tp9+Qb5enYBJCpiPWDA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/gat/cmd.version=v${version}"
  ];

<<<<<<< HEAD
  meta = {
    description = "Cat alternative written in Go";
    license = lib.licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with lib.maintainers; [ themaxmur ];
=======
  meta = with lib; {
    description = "Cat alternative written in Go";
    license = licenses.mit;
    homepage = "https://github.com/koki-develop/gat";
    maintainers = with maintainers; [ themaxmur ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gat";
  };
}

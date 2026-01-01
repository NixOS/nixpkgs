{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "matcha-rss-digest";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.7.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "matcha";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ezwZmJVJjbrrWJAsZ3+CUZ7K4WpA1HLKL9V+kTZTfj8=";
=======
    hash = "sha256-Zs6Och5CsqN2mpnCLgV1VkH4+CV1fklfP20A22rE5y0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-CURFy92K4aNF9xC8ik6RDadRAvlw8p3Xc+gWE2un6cc=";

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/piqoni/matcha";
    description = "Daily digest generator from a list of RSS feeds";
    license = lib.licenses.mit;
    mainProgram = "matcha";
    maintainers = [ ];
=======
  meta = with lib; {
    homepage = "https://github.com/piqoni/matcha";
    description = "Daily digest generator from a list of RSS feeds";
    license = licenses.mit;
    mainProgram = "matcha";
    maintainers = with maintainers; [ foo-dogsquared ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "pastel";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ISzZZNh9X91vBbVOpYXnYpO3ztGgIhMJTZmoY2T0FRw=";
  };

  cargoHash = "sha256-r0QiooMrTqFaXq2Y9wVW45zjtHT7qQ6XTWPRhlLpVQ8=";
=======
    sha256 = "sha256-kr2aLRd143ksVx42ZDO/NILydObinn3AwPCniXVVmY0=";
  };

  cargoHash = "sha256-u+1KDcC2KGqvmOk6k7hOHE16TMvDg92eMOdNMQQszug=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "pastel";
  };
}

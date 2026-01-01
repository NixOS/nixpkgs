{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  finalAttrs = {
    pname = "fm";
<<<<<<< HEAD
    version = "1.2.0";
=======
    version = "1.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    src = fetchFromGitHub {
      owner = "mistakenelf";
      repo = "fm";
      rev = "v${finalAttrs.version}";
<<<<<<< HEAD
      hash = "sha256-5+hwubyMgnyYPR7+UdK8VEyk2zo4kniBu7Vj4QarvMg=";
    };

    vendorHash = "sha256-uhrE8ZuUeQSm+Jg1xi83RsBrzjex+aBlElJRT61k0BU=";
=======
      hash = "sha256-m0hjLXgaScJydwiV00b8W7f1y1Ka7bbYqcMPAOw1j+c=";
    };

    vendorHash = "sha256-/tUL08Vo3W7PMPAnJA9RPdMl0AwZj8BzclYs2257nqM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    meta = {
      homepage = "https://github.com/mistakenelf/fm";
      description = "Terminal based file manager";
      changelog = "https://github.com/mistakenelf/fm/releases/tag/${finalAttrs.src.rev}";
      license = with lib.licenses; [ mit ];
      mainProgram = "fm";
      maintainers = [ ];
    };
  };
in
buildGoModule finalAttrs

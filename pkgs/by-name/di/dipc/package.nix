{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "dipc";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "doprz";
    repo = "dipc";
<<<<<<< HEAD
    rev = "b111b8cb997e3337974f861f44a73b557fb3c294";
    hash = "sha256-qP7LRwNIM92p5xQeuvQ03kwBM/HnRH+BniiKeYoihKw=";
  };

  cargoHash = "sha256-F6EYnkquvTsw4C7rl28Y1h9i9ChGccwZGkYSVrsEhVk=";

  meta = {
    description = "Convert your favorite images and wallpapers with your favorite color palettes/themes";
    homepage = "https://github.com/doprz/dipc";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      doprz
      ByteSudoer
    ];
=======
    rev = "bf578bd9474084b7099ef665138667e486dce671";
    hash = "sha256-RXEC8bwdnUOaDmYIb7ci/JD+vi16tBn55FRsUmwaRzk=";
  };

  cargoHash = "sha256-1vjVuAawuquPqem1as6xIv/ZJCzjgC4k0uyPSlrvpeg=";

  meta = with lib; {
    description = "Convert your favorite images and wallpapers with your favorite color palettes/themes";
    homepage = "https://github.com/doprz/dipc";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ ByteSudoer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "dipc";
  };
}

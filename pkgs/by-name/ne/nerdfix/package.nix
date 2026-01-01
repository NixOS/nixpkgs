{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nerdfix";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "loichyan";
    repo = "nerdfix";
    rev = "v${version}";
    hash = "sha256-Mp8QFzMQXJEFIzkrmiW/wxMy/+WC4VqbPtWzE92z9Gc=";
  };

  cargoHash = "sha256-8EchpubKnixlvAyM2iSf4fE5wowJHT6/mDHIvLPnEok=";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Helps you to find/fix obsolete nerd font icons in your project";
    mainProgram = "nerdfix";
    homepage = "https://github.com/loichyan/nerdfix";
    changelog = "https://github.com/loichyan/nerdfix/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
    ];
    maintainers = [ ];
  };
}

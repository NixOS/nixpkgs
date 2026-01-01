{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "choose";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "theryangeary";
    repo = "choose";
    rev = "v${version}";
    sha256 = "sha256-nqL8CAnpqOaecC6vHlCtVXFRO0OAGZAn12TdOM5iUFA=";
  };

  cargoHash = "sha256-NVpkCs1QY2e+WiI9nk1uz/j3pOtsJpMwgAMspB6Bs1E=";

<<<<<<< HEAD
  meta = {
    description = "Human-friendly and fast alternative to cut and (sometimes) awk";
    mainProgram = "choose";
    homepage = "https://github.com/theryangeary/choose";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sohalt ];
=======
  meta = with lib; {
    description = "Human-friendly and fast alternative to cut and (sometimes) awk";
    mainProgram = "choose";
    homepage = "https://github.com/theryangeary/choose";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

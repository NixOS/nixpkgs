{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "carl";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "b1rger";
    repo = "carl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lH4qHS3CjES3uZfRxIHOcnqxEXIxyAnho7xpi5rmLOM=";
=======
    hash = "sha256-bUSQArlCfgJr/XJuuyMVNFOZzJlmpInaEGHHxRZsDW4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = false;

<<<<<<< HEAD
  cargoHash = "sha256-ss/sGT2d4K8K9I5/G3UMRnv50O9JlB0tz9oS7sMylwI=";
=======
  cargoHash = "sha256-KueQLeqiHZfjyEdpURKXp6MigAcXdov8Z/KwKsiqv9Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "cal(1) with more features and written in rust";
    longDescription = ''
      Carl is a calendar for the commandline. It tries to mimic the various cal(1)
      implementations out there, but also adds enhanced features like colors and ical
      support
    '';
    homepage = "https://github.com/b1rger/carl";
    changelog = "https://github.com/b1rger/carl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "carl";
  };
}

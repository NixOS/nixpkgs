{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
<<<<<<< HEAD
  version = "latest-unstable-2025-12-09";
=======
  version = "latest-unstable-2025-11-24";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
<<<<<<< HEAD
    rev = "fde43ec216e70022bcc6d637249c5ef093b73aaf";
    hash = "sha256-Kd1MMxdrTbV8M8h1MW4REsGf+ehLvb8bXm9OzwGqUDA=";
  };

  cargoHash = "sha256-Upnm79E7pwoZR/13TnDob0Hbd3GNixtbB8gbrkLYGFQ=";
=======
    rev = "c04a05ebaf7488a44d227c66a53b17c7f670f9ad";
    hash = "sha256-DKHaHVuxq/ZjOa0jz/2mMiqptELx+h671M20eByrBHY=";
  };

  cargoHash = "sha256-cH+cgYIUPQTHgGCZmP562VzCxz+i6LkymHtnHJXnd+A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}

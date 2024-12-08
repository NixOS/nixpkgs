{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
  buildGoModule rec {
    pname = "gamut-cli";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "nikolaizombie1";
      repo = "gamut-cli";
      rev = "v${version}";
      hash = "sha256-ayBpx9GRE0pkVl8Zo9clsEoW+3Gwd7ynl5Ov1XO8q1I=";
    };

    vendorHash = "sha256-2KtQpzgz6xTupbejkm95OVxnamZmBwanPmzUkjzkB+o=";

    meta = with lib; {
      description = "A command line interface for the gamut library made by muesli.";
      homepage = "https://github.com/nikolaizombie1/gamut-cli/tree/main";
      license = lib.licenses.gpl3;
      maintainers = [
        {
          name = "Fabio J. Matos Nieves";
          email = "fabio.matos999@gmail.com";
          githubId = "70602908";
          github = "nikolaizombie1";
        }
      ];
    };
  }

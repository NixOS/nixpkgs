{
  rustPlatform,
  fetchFromGitHub,
  lib,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "color-scheme-generator";
  version = "0.9.2.1";

  src = fetchFromGitHub {
    owner = "nikolaizombie1";
    repo = "color_scheme_generator";
    rev = "v${version}";
    hash = "sha256-tSoM6MP58vOoKRMQjNq8nKMiVTfS9N/mckchAPcUM0g=";
  };

  cargoHash = "sha256-A8ld2c8ZcqaZN29Fz085FQy8UpugIDMOKT01r+SfCcc=";

  nativeBuildInputs = [ perl ];

  meta = with lib; {
    description = "Quickly generate color schemes for waybar from an image.";
    longDescription = ''
      color_scheme_generator is a command line utility used to analyze images and generate color themes from them given a path to an image.

      This command line utility behaves like a standard UNIX utility where the path to the image can be either piped in or sent a command line argument.

      The intended purpose of this application is to automatically create color themes for Waybar, but it can be used for the bar in AwesomeWM or other applications to theme based on the on an image. This utility has a cache for the image analysis. This means that once an image has been analyzed once, the result will be saved in the cache and when an image is analyzed again, the results will be returned instantly

    '';
    homepage = "https://github.com/nikolaizombie1/color_scheme_generator";
    license = licenses.gpl3;
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

{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "meow";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "PixelSergey";
    repo = "meow";
    rev = "v${version}";
    hash = "sha256-iskpT0CU/cGp+8myWaVmdw/uC0VoP8Sv+qbjpDDKS3o=";
  };

  cargoHash = "sha256-/XzXgbmgJ1EN3cQmgWNMUpYtNWRlwJ0mvaQWCsP3FMk=";

  postInstall = ''
    mv $out/bin/meow-cli $out/bin/meow
  '';

  meta = {
    description = "Print ASCII cats to your terminal";
    homepage = "https://github.com/PixelSergey/meow";
    license = lib.licenses.mit;
    mainProgram = "meow";
    maintainers = with lib.maintainers; [ pixelsergey ];
  };
}

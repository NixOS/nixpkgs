{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "okolors";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Ivordir";
    repo = "Okolors";
    rev = "v${version}";
    sha256 = "sha256-xroiiDTm3B2sVC1sO7oe3deqh+j3URmiy/ctwqrvvkI=";
  };

  cargoHash = "sha256-Ru7VZM+vLGkYeLqWilQvpWUnbNZqkJHn1D/Vo/KUmRk=";

  meta = with lib; {
    description = "Generate a color palette from an image using k-means clustering in the Oklab color space";
    homepage = "https://github.com/Ivordir/Okolors";
    license = licenses.mit;
    maintainers = with maintainers; [ laurent-f1z1 ];
    mainProgram = "okolors";
  };
}

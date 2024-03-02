{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "nom";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    rev = "v${version}";
    hash = "sha256-PBhwIyGzWbXRTmp+IvFPqae4cbb6l6nIYcFheYkHlFI=";
  };

  vendorHash = "sha256-fP6yxfIQoVaBC9hYcrCyo3YP3ntEVDbDTwKMO9TdyDI=";

  meta = with lib; {
    homepage = "https://github.com/guyfedwards/nom";
    description = "RSS reader for the terminal";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nadir-ishiguro ];
    mainProgram = "nom";
  };
}

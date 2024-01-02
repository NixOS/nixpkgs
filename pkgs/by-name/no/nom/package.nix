{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "nom";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    rev = "v${version}";
    hash = "sha256-mYE8cu7qHRyG/pZSr4u6tMEF3ZM5Qz+CX+oLf/chwl4=";
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

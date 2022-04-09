{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "f1viewer";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "SoMuchForSubtlety";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z6rnkHypk7r9NnYwqZpWQOuGPbWn/EppS+46PQHIdDM=";
  };

  vendorSha256 = "sha256-UNeH3zxgssXxFpJws6nAL8EgXt0DRyAQfmlJWz/qyDg=";

  meta = with lib; {
    description =
      "A TUI to view Formula 1 footage using VLC or another media player";
    homepage = "https://github.com/SoMuchForSubtlety/f1viewer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michzappa ];
  };
}

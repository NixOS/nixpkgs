{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "f1viewer";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "SoMuchForSubtlety";
    repo = pname;
    rev = "v${version}";
    sha256 = "7eXRUG74l9+9nU7EmDvNcHc+2pg5+/amjqtrzT60f94=";
  };

  vendorSha256 = "4pQ8NT0mh3w7naHEHh2w6Csop0uitlWClZ95VlYaPW0=";

  meta = with lib; {
    description =
      "A TUI to view Formula 1 footage using VLC or another media player";
    homepage = "https://github.com/SoMuchForSubtlety/f1viewer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michzappa ];
  };
}

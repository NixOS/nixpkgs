{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ultralist";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ultralist";
    repo = "ultralist";
    rev = version;
    sha256 = "09kgf83jn5k35lyrnyzbsy0l1livzmy292qmlbx5dkdpaq5wxnmp";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Simple GTD-style todo list for the command line";
    homepage = "https://ultralist.io";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
  };
}

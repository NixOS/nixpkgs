{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fdkqfs87svpijccz8m11gvby8pvmznq6fs9k94vbzak0kxhw1wg";
  };

  vendorSha256 = "0avnskay23mpl3qkyf1h75rr7szpsxis2bj5pplhwf8q8q0212xf";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}" "-X main.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "Easily create & extract archives, and compress & decompress files of various formats";
    homepage = "https://github.com/mholt/archiver";
    mainProgram = "arc";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}

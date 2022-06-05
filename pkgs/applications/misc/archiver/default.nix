{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1py186hfy4p69wghqmbsyi1r3xvw1nyl55pz8f97a5qhmwxb3mwp";
  };

  vendorSha256 = "1y4v95z1ga111g3kdv5wvyikwifl25f36firf1i916rxli6f6g5i";

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

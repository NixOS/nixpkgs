{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fi86g27c660g3mv9c5rfm0mmvh5q08704c19xnvrpwlg65glqrz";
  };

  vendorSha256 = "1rqhra3rfarq8f750zszkrm0jcsxa4sjbfpmcdlj5z000df699zq";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev} -X main.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "Easily create & extract archives, and compress & decompress files of various formats";
    homepage = "https://github.com/mholt/archiver";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}

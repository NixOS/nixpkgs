{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1izr9znw3mbqpg85qkl1pad5hash531h3dpwbji5w2af2i6x4ga3";
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

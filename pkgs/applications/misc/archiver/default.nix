{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "archiver";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "mholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "16jawybywqfkp68035bnf206a2w4khjw239saa429a21lxrfyk4a";
  };

  vendorSha256 = "0m89ibj3dm58j49d99dhkn0ryivnianxz7lkpkvhs0cdbzzc02az";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.commit=${src.rev} -X main.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "Easily create & extract archives, and compress & decompress files of various formats";
    homepage = "https://github.com/mholt/archiver";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}

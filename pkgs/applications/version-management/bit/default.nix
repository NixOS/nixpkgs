{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bit";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "chriswalz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rdi6wsr5w64gvqkdysxrxfjxi3xbwigy3sk8wsx9zp4fql9xnw1";
  };

  subPackages = [ "." ];

  vendorSha256 = "16c1mcvz3z17pixp904hazivx2n7y592nlx3ndnyajk7ljmnwfzy";

  meta = with lib; {
    description = "Bit is a modern Git CLI";
    homepage = "https://github.com/chriswalz/bit";
    license = licenses.mit;
    maintainers = with maintainers; [ rople380 ];
  };
}

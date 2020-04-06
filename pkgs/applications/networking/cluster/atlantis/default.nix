{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "1ylk6n13ln6yaq4nc4n7fm00wfiyqi2x33sca5avzsvd1b387kk6";
  };

  modSha256 = "1bhplk3p780llpj9l0fwcyli74879968d6j582mvjwvf2winbqzq";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}

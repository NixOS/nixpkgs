{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "08k2dgz6rph68647ah1rdp7hqa5h1ar4gdy7vdjy5kn7gz21gmri";
  };

  modSha256 = "1i4s3xcq2qc3zy00wk2l77935ilm6n5k1msilmdnj0061ia4860y";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = https://github.com/runatlantis/atlantis;
    description = "Terraform Pull Request Automation";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}

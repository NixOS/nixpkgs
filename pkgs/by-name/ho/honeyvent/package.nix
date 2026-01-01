{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "honeyvent";
  version = "1.1.3";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeyvent";
    rev = "v${version}";
    hash = "sha256-L8hM4JJDDfVv/0O8H3lcI0SRVjDMYC82HG/4WU6Vim8=";
  };

<<<<<<< HEAD
  meta = {
    description = "CLI for sending individual events to honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iand675 ];
=======
  meta = with lib; {
    description = "CLI for sending individual events to honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

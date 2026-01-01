{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-protobuf";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "sha256-AfyZ6xlqmrsVqtoKV1XMEo/Vba9Kpu1EgwfF6pPSZ64=";
  };

  vendorHash = "sha256-jGAWUgW0DA7EwmlzVxnBmtbf2dp+P4Qwcb8mTAEhUi4=";

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/golang/protobuf";
    description = "Go bindings for protocol buffer";
    maintainers = with lib.maintainers; [ lewo ];
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    homepage = "https://github.com/golang/protobuf";
    description = "Go bindings for protocol buffer";
    maintainers = with maintainers; [ lewo ];
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

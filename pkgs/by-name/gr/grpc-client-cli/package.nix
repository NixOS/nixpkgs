{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-v7LqYA/IW9SHWlXQHl0E7aNxSOWc7zmTMzTEKYjRUl8=";
  };

  vendorHash = "sha256-NQUoAwrLMexDs0iRzGnuQ8E0hWVJBwtBUA9NI6/+AFU=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grpc-client-cli";
  version = "1.22.3";

  src = fetchFromGitHub {
    owner = "vadimi";
    repo = "grpc-client-cli";
    rev = "v${version}";
    sha256 = "sha256-6dUdyBmwX97Xvy7CYMUrpQxG25uPFyPFhwFI3QMzWtU=";
  };

  vendorHash = "sha256-Iiifu0dYgeqWUgWRjJ3uaBL6SyYl2Ehqzk+1COO/XXI=";

  meta = with lib; {
    description = "generic gRPC command line client";
    mainProgram = "grpc-client-cli";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/vadimi/grpc-client-cli";
    license = licenses.mit;
  };
}

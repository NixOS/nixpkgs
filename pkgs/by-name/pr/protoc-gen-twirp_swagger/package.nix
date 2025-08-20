{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "protoc-gen-twirp_swagger";
  version = "unstable-2021-03-29";

  src = fetchFromGitHub {
    owner = "elliots";
    repo = "protoc-gen-twirp_swagger";
    rev = "f21ef47d69e37c1602a7fb26146de05c092d30b6";
    sha256 = "sha256-uHU15NbHK7SYgNS3VK21H/OqDo/JyyTZdXw3i9lsgLY=";
  };

  vendorHash = "sha256-g0+9l83Fc0XPzsZAKjLBrjD+tv2+Fot57hcilqAhOZk=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Swagger generator for twirp";
    mainProgram = "protoc-gen-twirp_swagger";
    homepage = "https://github.com/elliots/protoc-gen-twirp_swagger";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}

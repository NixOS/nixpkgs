{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "antibody";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    tag = "v${version}";
    hash = "sha256-If7XAwtg1WqkDkrJ6qYED+DjwHWloPu3P7X9rUd5ikU=";
  };

  vendorHash = "sha256-0m+yDo+AMX5tZfOsjsZgulyjB9mVEjy2RfA2sYeqDn0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

<<<<<<< HEAD
  meta = {
    description = "Fastest shell plugin manager";
    mainProgram = "antibody";
    homepage = "https://github.com/getantibody/antibody";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Fastest shell plugin manager";
    mainProgram = "antibody";
    homepage = "https://github.com/getantibody/antibody";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # golang.org/x/sys needs to be updated due to:
    #
    #   https://github.com/golang/go/issues/49219
    #
    # but this package is no longer maintained.
    #
    broken = stdenv.hostPlatform.isDarwin;
  };
}

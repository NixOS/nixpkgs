{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VAbMcON75dTS+1lUqmveN2WruQCCmK3kB86e+vKM64U=";
  };

  vendorHash = "sha256-JaYJq8lnZHK75Rwif77A9y9jTUoJFyoSZQgaExnY+rM=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "Third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "hydroxide";
  };
}

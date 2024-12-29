{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule {
  pname = "rHttp";
  version = "unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "1buran";
    repo = "rHttp";
    rev = "9b7da3a0f7c2e35c9d326e7920ded15f806f8113";
    sha256 = "1nz3f6zgpbxlwn6c5rqxa8897ygi5r7h7f6624i27rq9kr729cra";
  };

  vendorHash = "sha256-NR1q44IUSME+x1EOcnXXRoIXw8Av0uH7iXhD+cdd99I=";

  meta = with lib; {
    description = "Go REPL for HTTP";
    homepage = "https://github.com/1buran/rHttp";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ luftmensch-luftmensch ];
    mainProgram = "rhttp";
  };
}

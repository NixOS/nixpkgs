{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "easyjson";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "v${version}";
    hash = "sha256-aKufvebodIy0UtecpjZ9+5MOUTWKFIqFI3SYgVPWdhQ=";
  };
  vendorHash = "sha256-BsksTYmfPQezbWfIWX0NhuMbH4VvktrEx06C2Nb/FYE=";

  subPackages = [ "easyjson" ];

  meta = with lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for Go";
    mainProgram = "easyjson";
    license = licenses.mit;
  };
}

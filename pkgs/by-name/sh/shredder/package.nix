{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  name = "shredder";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "shredder";
    rev = "5b5dd3506e0917341105b57edd98851a69dd5935";
    hash = "sha256-T/IVEutcEnMkMHiM2KEp4d8UzA06xsYbeMvRnBj2Me8=";
  };
  vendorHash = null;
  meta = with lib; {
    description = "Secure file deletion for the paranoid ones";
    homepage = "https://github.com/NewDawn0/shredder";
    maintainers = with maintainers; [NewDawn0];
    license = licenses.mit;
  };
}

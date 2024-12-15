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
  meta = {
    description = "A tool for securely deleting files to ensure privacy";
    longDescription = ''
      This tool securely deletes files, ensuring they cannot be recovered.
      Ideal for users who require extra privacy and need to ensure sensitive data is completely erased from their system.
    '';
    homepage = "https://github.com/NewDawn0/shredder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}

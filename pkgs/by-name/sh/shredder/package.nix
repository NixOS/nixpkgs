{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  pname = "shredder";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "shredder";
    rev = "v1.0.0";
    hash = "sha256-0Oz92/KABODmEqaQHHpeK9/tf7Ws+PdRrzQuTzxulQA=";
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

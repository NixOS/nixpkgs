{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nova-password";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = "nova-password";
    tag = "v${version}";
    hash = "sha256-+RW+uJ9mLEiNMGYio+FcAJHvga8uzDLmgcylwoUJIho=";
  };

  vendorHash = "sha256-7Hg5s3yZezLVwoUoeF4125QtjeLSCcsjnCD6+zbMz8I=";

  meta = {
    description = "Decrypt the admin password generated for the VM in OpenStack";
    homepage = "https://github.com/sapcc/nova-password";
    license = lib.licenses.asl20;
    mainProgram = "nova-password";
    maintainers = with lib.maintainers; [ vinetos ];
    platforms = lib.platforms.all;
  };
}

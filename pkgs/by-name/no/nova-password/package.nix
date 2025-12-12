{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "nova-password";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = "nova-password";
    tag = "v${version}";
    hash = "sha256-73o/dSS/cmLnie4Rbc3FOzRS2clw17GI7gk2nW1u3/I=";
  };

  vendorHash = "sha256-8eBS4kczObQZksK/bS/guv8nBNY0DInJ4Dk1Hlr2B7A=";

  meta = {
    description = "Decrypt the admin password generated for the VM in OpenStack";
    homepage = "https://github.com/sapcc/nova-password";
    license = lib.licenses.asl20;
    mainProgram = "nova-password";
    maintainers = with lib.maintainers; [ vinetos ];
    platforms = lib.platforms.all;
  };
}

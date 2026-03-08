{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "cloudmonkey";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = finalAttrs.version;
    sha256 = "sha256-CdqKaKUVqeAujrWh7u0npZ6ON/nmL/8uIBIljAPPUv0=";
  };

  vendorHash = null;

  meta = {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.womfoo ];
    mainProgram = "cloudstack-cloudmonkey";
  };

})

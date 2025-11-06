{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "cloudmonkey";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = version;
    sha256 = "sha256-CdqKaKUVqeAujrWh7u0npZ6ON/nmL/8uIBIljAPPUv0=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
    mainProgram = "cloudstack-cloudmonkey";
  };

}

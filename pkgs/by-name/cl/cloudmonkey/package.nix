{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "cloudmonkey";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = version;
    sha256 = "sha256-mkEGOZw7GDIFnYUpgvCetA4dU9R1m4q6MOUDG0TWN64=";
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

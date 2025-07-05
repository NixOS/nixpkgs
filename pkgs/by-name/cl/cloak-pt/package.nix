{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.11.0";
in
buildGoModule {
  pname = "Cloak";
  inherit version;

  src = fetchFromGitHub {
    owner = "cbeuw";
    repo = "Cloak";
    rev = "v${version}";
    hash = "sha256-afFOWjJiqlMeo8M8D2RsW572c2qTthMNbQvxEf7edHE=";
  };

  vendorHash = "sha256-P3/fB1vJjEMETyFxH9XNQySCEDQWrbZdaf0V4qFucbI=";

  doCheck = false;

  ldflags = [ "-X main.version=${version}" ];
  meta = {
    homepage = "https://github.com/cbeuw/Cloak/";
    description = "Pluggable transport that enhances traditional proxy tools like OpenVPN to evade sophisticated censorship and data discrimination";
    longDescription = ''
      Cloak is not a standalone proxy program. Rather, it works by masquerading proxied traffic as normal web browsing activities.

      To any third party observer, a host running Cloak server is indistinguishable from an innocent web server.
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ bananad3v ];
  };
}

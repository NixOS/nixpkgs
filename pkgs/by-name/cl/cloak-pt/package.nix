{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.12.0";
in
buildGoModule {
  pname = "Cloak";
  inherit version;

  src = fetchFromGitHub {
    owner = "cbeuw";
    repo = "Cloak";
    rev = "v${version}";
    hash = "sha256-789UyTJmIhujsg0OlCy8GqUxgHDjzkGUi5kHD5sytwQ=";
  };

  vendorHash = "sha256-LOXPs/3qkP3GJZZ7W4rPOfAjmvNh1mowRuQ1tlV1uC4=";

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

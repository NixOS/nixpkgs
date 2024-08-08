{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "Cloak";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "BANanaD3V"; # Actual upstream (cbeuw) got a go.mod issue so we use this
    repo = "Cloak";
    rev = "6b08af0";
    hash = "sha256-2nk/sz2pNVt7rM+6omj+FK1U039swFqjHmnE4n3YC4E=";
  };

  vendorHash = "sha256-xyzFsk1frnj+HbYpXTjrZzD1NM5mokNv6maCA4CsT/w=";

  doCheck = false;

  ldflags = [
    "-X main.version=master(6b08af0)"
  ];
  meta = with lib; {
    homepage = "https://github.com/cbeuw/Cloak/";
    description = "Cloak is a pluggable transport that enhances traditional proxy tools like OpenVPN to evade sophisticated censorship and data discrimination.";
    longDescription = ''
      Cloak is not a standalone proxy program. Rather, it works by masquerading proxied traffic as normal web browsing activities. In contrast to tra>

      To any third party observer, a host running Cloak server is indistinguishable from an innocent web server. Both while passively observing traff>
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ bananad3v ];
  };
}





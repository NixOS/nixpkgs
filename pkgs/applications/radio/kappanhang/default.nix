{ lib, buildGoModule, fetchFromGitHub, pkg-config, pulseaudio }:

buildGoModule rec {
  pname = "kappanhang";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "nonoo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-l0V2NVzLsnpPe5EJcr5i9U7OGaYzNRDd1f/ogrdCnvk=";
  };

  vendorHash = "sha256-CnZTUP2JBbhG8VUHbVX+vicfQJC9Y8endlwQHdmzMus=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pulseaudio ];

  meta = with lib; {
    homepage = "https://github.com/nonoo/kappanhang";
    description = "Remote control for Icom radio transceivers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvs ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  pulseaudio,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kappanhang";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "nonoo";
    repo = "kappanhang";
    rev = "v${version}";
    hash = "sha256-l0V2NVzLsnpPe5EJcr5i9U7OGaYzNRDd1f/ogrdCnvk=";
  };

  vendorHash = "sha256-CnZTUP2JBbhG8VUHbVX+vicfQJC9Y8endlwQHdmzMus=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pulseaudio ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/nonoo/kappanhang";
    description = "Remote control for Icom radio transceivers";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mvs ];
    mainProgram = "kappanhang";
  };
}

{
  buildGoModule,
  fetchFromSourcehut,
  lib,
  libx11,
}:

buildGoModule {
  pname = "photon";
  version = "unstable-2022-01-11";

  src = fetchFromSourcehut {
    owner = "~ghost08";
    repo = "photon";
    rev = "5d1f7dd8d0d526096886b03c7bc0ef56cbdd6d79";
    sha256 = "sha256-2RSGLWfthcChd5YhDSBfLSch6wuTUv1Sh1f7flgzQwc=";
  };

  buildInputs = [ libx11 ];

  proxyVendor = true;

  vendorHash = "sha256-n9XNqXIoqn+f0xKCenJWXUYXtQhtbNBar68onWH/WV4=";

  meta = {
    description = "RSS/Atom reader with the focus on speed, usability and a bit of unix philosophy";
    mainProgram = "photon";
    homepage = "https://sr.ht/~ghost08/photon";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kmein ];
    platforms = lib.platforms.linux;
  };
}

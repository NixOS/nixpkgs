{ buildGoModule, fetchFromSourcehut, lib, xorg }:

buildGoModule rec {
  pname = "photon";
  version = "unstable-2022-01-11";

  src = fetchFromSourcehut {
    owner = "~ghost08";
    repo = "photon";
    rev = "5d1f7dd8d0d526096886b03c7bc0ef56cbdd6d79";
    sha256 = "sha256-2RSGLWfthcChd5YhDSBfLSch6wuTUv1Sh1f7flgzQwc=";
  };

  buildInputs = [ xorg.libX11 ];

  proxyVendor = true;

  vendorSha256 = "sha256-1vlgnY4kZJfoAtbv+r8onxL03Ak32zKLJgtrBYZX09g=";

  meta = with lib; {
    description = "RSS/Atom reader with the focus on speed, usability and a bit of unix philosophy";
    homepage = "https://sr.ht/~ghost08/photon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kmein ];
    platforms = platforms.linux;
  };
}

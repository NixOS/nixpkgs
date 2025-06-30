{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "dn42-cacert";

  # check root-ca.crt in https://ca.dn42.us/crt/
  version = "0-unstable-2018-06-22";

  src = ./root-ca.crt;

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    install -Dm644 $src $out/etc/ssl/certs/dn42-ca.crt
  '';

  meta = {
    description = "DN42 Root CA certificate";
    homepage = "https://wiki.dn42.dev/services/Certificate-Authority.md";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ Cryolitia ];
    platforms = lib.platforms.all;
  };
}

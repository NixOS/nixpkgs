{
  stdenv,
  lib,
  hockeypuck,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "hockeypuck-web";

  inherit (hockeypuck) version src;

  dontBuild = true; # We should just copy the web templates

  installPhase = ''
    mkdir -p $out/share/

    cp -vr contrib/webroot $out/share/
    cp -vr contrib/templates $out/share/
  '';

  passthru.tests = nixosTests.hockeypuck;

  meta = {
    description = "OpenPGP Key Server web resources";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}

{
  stdenv,
  lib,
  hockeypuck,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "hockeypuck-web";

  strictDeps = true;
  __structuredAttrs = true;

  inherit (hockeypuck) version src;

  dontBuild = true; # We should just copy the web templates

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/

    cp -vr contrib/webroot $out/share/
    cp -vr contrib/templates $out/share/

    runHook postInstall
  '';

  passthru.tests = nixosTests.hockeypuck;

  meta = {
    description = "OpenPGP Key Server web resources";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    teams = with lib.teams; [ ngi ];
  };
}

{
  stdenv,
  lib,
  hockeypuck,
}:

stdenv.mkDerivation {
  pname = "hockeypuck-web";
  inherit (hockeypuck) version src;

  __structuredAttrs = true;
  strictDeps = true;

  dontBuild = true; # We should just copy the web templates

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/

    cp -vr contrib/webroot $out/share/
    cp -vr contrib/templates $out/share/

    runHook postInstall
  '';

  passthru = {
    inherit (hockeypuck.passthru) tests;
  };

  meta = {
    description = "OpenPGP Key Server web resources";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = lib.licenses.gpl3Plus;
    inherit (hockeypuck.meta) teams;
  };
}

{
  stdenv,
  fetchurl,
  undmg-hdiutil,
  meta,
  pname,
  version,
  url,
  hash,
  passthru,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    inherit url hash;
  };

  # dmg is APFS formatted
  nativeBuildInputs = [ undmg-hdiutil ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';

  # LM Studio ships Scripts inside the App Bundle, which may be messed up by standard fixups
  dontFixup = true;

  inherit passthru;
}

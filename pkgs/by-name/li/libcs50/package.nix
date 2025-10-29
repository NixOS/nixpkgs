{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcs50";
  version = "11.0.3";

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "libcs50";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G6QayPGR4lkeFuUYsFszekLAzzpA3hhIRmqt/OB0cdY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R build/lib $out/lib
    cp -R build/include $out/include
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cs50/libcs50";
    description = "CS50 Library for C";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})

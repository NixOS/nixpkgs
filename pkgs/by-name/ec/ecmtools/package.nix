{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ecm-tools";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "alucryd";
    repo = "ecm-tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DCxrSTUO+e350zI10D8vpIswxqdfAyQfnY4iz17pfuc=";
  };

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install --directory --mode=755 $out/bin
    install --mode=755 bin2ecm $out/bin
    pushd $out/bin
    ln -s bin2ecm ecm2bin
    popd

    runHook postInstall
  '';

  meta = {
    description = "A utility to uncompress ECM files to BIN CD format";
    homepage = "https://github.com/alucryd/ecm-tools";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bin2ecm";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})

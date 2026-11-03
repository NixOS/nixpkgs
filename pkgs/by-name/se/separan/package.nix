{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "separan";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/mocchii2/Separan/releases/download/v${finalAttrs.version}/separan-linux-source.tar.gz";
    hash = "sha256-MN/4bmNEteUGz9Fsv0Ng9jiMjii+SkQR9Aug1Fgu/ds=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  buildFlags = [ "separan" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 separan $out/bin/separan

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    version_output=$($out/bin/separan --version)
    test "$version_output" = "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "Structural programming language - native C core runtime";
    homepage = "https://github.com/mocchii2/Separan";
    changelog = "https://github.com/mocchii2/Separan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mocchii2 ];
    mainProgram = "separan";
    platforms = lib.platforms.unix;
  };
})

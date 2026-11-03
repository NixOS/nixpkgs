{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "separan-gw";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/mocchii2/Separan/releases/download/v${finalAttrs.version}/separan-linux-source.tar.gz";
    hash = "sha256-MN/4bmNEteUGz9Fsv0Ng9jiMjii+SkQR9Aug1Fgu/ds=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  buildFlags = [ "separan-gw" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 separan-gw $out/bin/separan-gw
    install -Dm644 docs/separan-gw.md docs/separan-gw.ja.md -t $out/share/doc/separan-gw
    install -Dm644 docs/separan-gw.conf.example -t $out/share/doc/separan-gw

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    version_output=$($out/bin/separan-gw --version)
    test "$version_output" = "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "FastCGI / stdio / socket gateway worker for the Separan language runtime";
    homepage = "https://github.com/mocchii2/Separan";
    changelog = "https://github.com/mocchii2/Separan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mocchii2 ];
    mainProgram = "separan-gw";
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fortify-headers";
  version = "3.0.1";

  # upstream only accessible via git - unusable during bootstrap, hence
  # extract from GitHub release.
  src = fetchurl {
    url = "https://github.com/jvoisin/fortify-headers/archive/refs/tags/${finalAttrs.version}.tar.gz";
    hash = "sha256-V2rB3C25pQPYRYwen0ps6LBDfPw8UHhZ12AaO42KwOY=";
  };

  patches = [
    ./wchar-imports-skip.patch
    ./restore-macros.patch
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r include $out/include

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "git://git.2f30.org/fortify-headers";
  };

  meta = {
    description = "Standalone header-based fortify-source implementation";
    homepage = "https://git.2f30.org/fortify-headers";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})

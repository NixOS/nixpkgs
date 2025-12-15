{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mymake";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "fstromback";
    repo = "mymake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FVY6Ep6619W3fMDRYdU/FdnltNUahkY33aVhz8kXEGU=";
  };

  buildPhase = ''
    runHook preBuild

    ./compile.sh mm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 mm $out/bin/mm

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for compiling and running programs with minimal configuration";
    homepage = "https://github.com/fstromback/mymake";
    maintainers = [ lib.maintainers.nobbele ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "mm";
  };
})

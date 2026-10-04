{
  lib,
  stdenv,
  fetchFromGitLab,
  buildPackages,
  installFonts,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "console-braille";
  version = "1.12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "a11y-team";
    repo = "console-braille";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-TaPFEGdoY6yZICCENF1275q0CydVCR5b8JHY7vXjjFg=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    installFonts
    installShellFiles
  ];

  makeFlags = [
    "BUILD_CC=$(CC_FOR_BUILD)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  env.LC_ALL = "C.UTF-8";

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin setbrlkeys gen-psf-block
    for arch in keymaps/*; do
      install -Dm644 -t $out/share/$arch/include $arch/include/*
    done
    installManPage setbrlkeys.1

    runHook postInstall
  '';

  meta = {
    description = "Braille fonts and keymaps for the Linux console";
    homepage = "https://salsa.debian.org/a11y-team/console-braille";
    changelog = "https://salsa.debian.org/a11y-team/console-braille/-/blob/${finalAttrs.src.tag}/debian/changelog";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})

{
  lib,
  stdenv,
  linuxPackages_latest,
  python3,
  man,
}:

stdenv.mkDerivation {
  pname = "linux-manual";
  inherit (linuxPackages_latest.kernel) version src;

  nativeBuildInputs = [ python3 ];
  nativeInstallCheckInputs = [ man ];

  dontConfigure = true;
  doInstallCheck = true;

  postPatch = ''
    # Releases up to including 6.19.3 still use scripts/kernel-doc.py, but it
    # has been moved to tools/docs with 7.0-rc1.
    patchShebangs --build \
      tools/docs \
      scripts/kernel-doc.py
  '';

  buildPhase = ''
    runHook preBuild

    # avoid Makefile because it checks for unnecessary Python dependencies
    KBUILD_BUILD_TIMESTAMP="$(date -u -d "@$SOURCE_DATE_EPOCH")" \
    tools/docs/sphinx-build-wrapper mandocs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/man"
    cp -r output/man "$out/share/man/man9"

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    # Check for well‐known man page
    man -M "$out/share/man" -P cat 9 kmalloc >/dev/null

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://kernel.org/";
    description = "Linux kernel API manual pages";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = lib.platforms.linux;
  };
}

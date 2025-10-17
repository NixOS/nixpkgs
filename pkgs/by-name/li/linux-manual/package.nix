{
  lib,
  stdenv,
  linuxPackages_latest,
  perl,
  python3,
  man,
}:

stdenv.mkDerivation {
  pname = "linux-manual";
  inherit (linuxPackages_latest.kernel) version src;

  nativeBuildInputs = [
    perl
    python3
  ];
  nativeInstallCheckInputs = [ man ];

  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = true;

  postPatch = ''
    # Use scripts/kernel-doc.py here, not scripts/kernel-doc because
    # patchShebangs skips symlinks

    patchShebangs --build \
      scripts/kernel-doc.py \
      scripts/split-man.pl
  '';

  installPhase = ''
    runHook preInstall

    export mandir="$out/share/man/man9"
    mkdir -p "$mandir"

    KBUILD_BUILD_TIMESTAMP="$(date -u -d "@$SOURCE_DATE_EPOCH")" \
    grep -F -l -Z \
      --exclude-dir Documentation \
      --exclude-dir tools \
      -R '/**' \
      | xargs -0 -n 256 -P "$NIX_BUILD_CORES" \
        "$SHELL" -c '{ scripts/kernel-doc -man "$@" || :; } \
          | scripts/split-man.pl "$mandir"' kernel-doc

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

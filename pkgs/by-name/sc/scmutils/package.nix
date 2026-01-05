{
  stdenv,
  fetchurl,
  lib,
  mitschemeX11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "scmutils";
  version = "20230902";

  src = fetchurl {
    url = "https://groups.csail.mit.edu/mac/users/gjs/6946/mechanics-system-installation/native-code/scmutils-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-9/shOxoKwJ4uDTHmvXqhemgy3W+GUCmoqFm5e1t3W0M=";
  };

  buildInputs = [ mitschemeX11 ];

  configurePhase = ''
    runHook preConfigure
    ln -r -s kernel/ghelper-pro.scm kernel/ghelper.scm
    ln -r -s solve/nnsolve.scm solve/solve.scm
    substituteInPlace load.scm \
      --replace-fail '/usr/local/scmutils/' "$out/lib/mit-scheme/"
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    echo '(load "compile")' | mit-scheme --no-init-file --batch-mode --interactive
    echo '(load "load") (disk-save "edwin-mechanics.com")' | mit-scheme --no-init-file --batch-mode --interactive
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/mit-scheme/" "$out/share/scmutils" "$out/bin"
    cp edwin-mechanics.com "$out/lib/mit-scheme/"
    declare -r TARGET="$out/lib/mit-scheme/"
    for SRC in $(find * -type f -name '*.bci'); do
      install -d "$TARGET"scmutils/"$(dirname "$SRC")"
      cp -a "$SRC" "$TARGET"scmutils/"$SRC"
    done
    # Convenience script to load the band
    declare -r CMD="exec ${mitschemeX11}/bin/mit-scheme --band $out/lib/mit-scheme/edwin-mechanics.com"
    echo "#!$SHELL" > $out/bin/scmutils
    echo "$CMD" "\"\$@\"" >> $out/bin/scmutils
    echo "#!$SHELL" > $out/bin/edwin-scmutils
    echo "$CMD" "--edit" "\"\$@\"" >> $out/bin/edwin-scmutils
    chmod uog+rx "$out/bin/scmutils" "$out/bin/edwin-scmutils"
    ln -r -s "$out/bin/edwin-scmutils" "$out/bin/mechanics"
    runHook postInstall
  '';

  meta = {
    description = "Scheme library for mathematical physics";

    longDescription = ''
      Scmutils system is an integrated library of procedures,
      embedded in the programming language Scheme, and intended
      to support teaching and research in mathematical physics
      and electrical engineering.
    '';

    homepage = "https://groups.csail.mit.edu/mac/users/gjs/6.5160/installation.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.fbeffa ];
  };
})

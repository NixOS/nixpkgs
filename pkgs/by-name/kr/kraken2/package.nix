{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  rsync,
  perl,
  wget,
  zlib,
  python3,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kraken2";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "DerrickWood";
    repo = "kraken2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ZW29SXWzy/fZreOmNnjywwlaSReZXnqq+uzGsuWP2g=";
  };

  nativeBuildInputs = [
    perl
    makeWrapper
  ];

  buildInputs =
    [ zlib.dev ]
    # TODO: may mismatch LLVM version (#79818)
    ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  installPhase = ''
    runHook preInstall

    substituteInPlace install_kraken2.sh \
      --replace-fail ${lib.escapeShellArg ''KRAKEN2_DIR=$(perl -MCwd=abs_path -le 'print abs_path(shift)' "$1")''} 'KRAKEN2_DIR="$1"'
    ./install_kraken2.sh "$out/libexec/kraken2"

    mkdir -p $out/bin
    ln -s $out/libexec/kraken2/kraken2 $out/bin
    ln -s $out/libexec/kraken2/kraken2-build $out/bin
    ln -s $out/libexec/kraken2/kraken2-inspect $out/bin
    ln -s $out/libexec/kraken2/k2 $out/bin
    for file in $out/libexec/kraken2/* ; do
      if [ -x "$file" ] ; then
        wrapProgram "$file" \
          --prefix PATH : $out/libexec/kraken2:${
            lib.makeBinPath [
              wget
              perl
              rsync
              python3
            ]
          }
        fi
      done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The second version of the Kraken taxonomic sequence classification system.";
    homepage = "https://ccb.jhu.edu/software/kraken2/";
    downloadPage = "https://github.com/DerrickWood/kraken2";
    changelog = "https://github.com/DerrickWood/kraken2/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      cardealerT
      A1egator
      jbedo
    ];
  };
})

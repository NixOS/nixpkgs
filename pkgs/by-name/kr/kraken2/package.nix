{
  lib,
  stdenv,
  fetchFromGitHub,
  rsync,
  perl,
  wget,
  llvmPackages,
  zlib,
  python3,
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

  buildInputs = [
    rsync
    perl
    wget
    llvmPackages.openmp
    zlib
    python3
  ];

  installFlags = [ "KRAKEN2_DIR=$(out)/libexec/kraken2" ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/libexec/kraken2/kraken2 $out/bin
    ln -s $out/libexec/kraken2/kraken2-build $out/bin
    ln -s $out/libexec/kraken2/kraken2-inspect $out/bin
    ln -s $out/libexec/kraken2/k2 $out/bin
  '';

  meta = {
    description = "The second version of the Kraken taxonomic sequence classification system.";
    homepage = "https://ccb.jhu.edu/software/kraken2/";
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

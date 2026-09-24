{
  lib,
  stdenv,
  fetchzip,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "randtype";
  version = "1.13";

  src = fetchzip {
    url = "mirror://sourceforge/randtype/randtype-${finalAttrs.version}.tar.gz";
    sha256 = "055xs02qwpgbkn2l57bwghbsrsysg1zhm2asp0byvjpz4sc4w1rd";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/man/man1 $out/bin
    install -cp randtype.1.gz $out/share/man/man1
    install -cps randtype $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Semi-random text typer";
    mainProgram = "randtype";
    homepage = "https://benkibbey.wordpress.com/randtype/";
    maintainers = with lib.maintainers; [ dandellion ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/randtype.x86_64-darwin
  };
})

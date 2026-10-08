{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asciiquarium";
  version = "1.1";
  src = fetchurl {
    url = "https://robobunny.com/projects/asciiquarium/asciiquarium_${finalAttrs.version}.tar.gz";
    hash = "sha256-GwjGYTUl516HVG9OiYSrOzPx6SIIAmjHSfF3fVbJ02E=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp asciiquarium $out/bin
    chmod +x $out/bin/asciiquarium
    wrapProgram $out/bin/asciiquarium \
      --set PERL5LIB ${perlPackages.makeFullPerlPath [ perlPackages.TermAnimation ]}
  '';

  meta = {
    description = "Enjoy the mysteries of the sea from the safety of your own terminal";
    mainProgram = "asciiquarium";
    homepage = "https://robobunny.com/projects/asciiquarium/html/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      sigmasquadron
      utdemir
    ];
  };
})

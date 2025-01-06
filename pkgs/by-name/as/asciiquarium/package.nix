{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perlPackages,
}:

let
  version = "1.1";
in
stdenv.mkDerivation {
  pname = "asciiquarium";
  inherit version;
  src = fetchurl {
    url = "https://robobunny.com/projects/asciiquarium/asciiquarium_${version}.tar.gz";
    sha256 = "0qfkr5b7sxzi973nh0h84blz2crvmf28jkkgaj3mxrr56mhwc20v";
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
    description = "Enjoy the mysteries of the sea from the safety of your own terminal!";
    mainProgram = "asciiquarium";
    homepage = "https://robobunny.com/projects/asciiquarium/html/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      sigmasquadron
      utdemir
    ];
  };
}

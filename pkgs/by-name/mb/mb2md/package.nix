{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  perlPackages,
}:

let
  perlDeps = with perlPackages; [ TimeDate ];
in
stdenv.mkDerivation (finalAttrs: {
  version = "3.20";
  pname = "mb2md";

  src = fetchurl {
    url = "http://batleth.sapienti-sat.org/projects/mb2md/mb2md-${finalAttrs.version}.pl.gz";
    sha256 = "0bvkky3c90738h3skd2f1b2yy5xzhl25cbh9w2dy97rs86ssjidg";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ];

  unpackPhase = ''
    sourceRoot=.
    gzip -d < $src > mb2md.pl
  '';

  installPhase = ''
    install -D $sourceRoot/mb2md.pl $out/bin/mb2md
  '';

  postFixup = ''
    wrapProgram $out/bin/mb2md \
      --set PERL5LIB "${perlPackages.makePerlPath perlDeps}"
  '';

  meta = {
    description = "mbox to maildir tool";
    mainProgram = "mb2md";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jb55 ];
  };
})

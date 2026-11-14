{
  lib,
  fetchurl,
  perlPackages,
  pkg-config,
  fribidi,
}:

perlPackages.buildPerlPackage rec {
  pname = "urxvt-bidi";
  version = "2.15";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAMENSKY/Text-Bidi-${version}.tar.gz";
    hash = "sha256-NRhnaHfURvbCCmusdWcSCz6B9vfwjn2zZqrwSuLqxfA=";
  };

  nativeBuildInputs = [
    pkg-config
    perlPackages.ExtUtilsPkgConfig
  ];
  buildInputs = [ fribidi ];

  postInstall = ''
    install -Dm555 misc/bidi "$out/lib/urxvt/perl/bidi"
  '';

  passthru.perlPackages = [ "self" ];

  meta = {
    description = "Text::Bidi Perl package using fribidi, providing a urxvt plugin";
    homepage = "https://github.com/mkamensky/Text-Bidi";
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = with lib.platforms; unix;
    # Quote from the README:
    # same terms as the Perl 5 programming language system itself
    license = perlPackages.perl.meta.license;
  };
}

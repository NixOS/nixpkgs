{ lib, fetchurl, perlPackages, pkg-config, fribidi }:

perlPackages.buildPerlPackage rec {
  pname = "urxvt-bidi";
  version = "2.15";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAMENSKY/Text-Bidi-${version}.tar.gz";
    sha256 = "1w65xbi4mw5acsrpv3phyzv82ghb29kpbb3b1b1gcinlfxl6f61m";
  };

  nativeBuildInputs = [ pkg-config perlPackages.ExtUtilsPkgConfig ];
  buildInputs = [ fribidi ];

  postInstall = ''
    install -Dm555 misc/bidi "$out/lib/urxvt/perl/bidi"
  '';

  passthru.perlPackages = [ "self" ];

  meta = with lib; {
    description = "Text::Bidi Perl package using fribidi, providing a urxvt plugin";
    homepage = "https://github.com/mkamensky/Text-Bidi";
    maintainers = with maintainers; [ doronbehar ];
    platforms = with platforms; unix;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, gettext
, perl
, pkg-config
, libxml2
, pango
, cairo
, groff
, tcl
, darwin
, nixosTests
}:

perl.pkgs.toPerlModule (stdenv.mkDerivation rec {
  pname = "rrdtool";
  version = "1.8.0";
  outputs = [ "out" "dev" "doc" ];

  src = fetchFromGitHub {
    owner = "oetiker";
    repo = "rrdtool-1.x";
    rev = "v${version}";
     hash = "sha256-a+AxU1+YpkGoFs1Iu/CHAEZ4XIkWs7Vsnr6RcfXzsBE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gettext perl libxml2 pango cairo groff ]
    ++ lib.optionals stdenv.isDarwin [ tcl darwin.apple_sdk.frameworks.ApplicationServices ];

  postInstall = ''
    # for munin and rrdtool support
    mkdir -p $out/${perl.libPrefix}
    mv $out/lib/perl/5* $out/${perl.libPrefix}
  '';

  passthru.tests = { inherit (nixosTests) collectd; };

  meta = {
    homepage = "https://oss.oetiker.ch/rrdtool/";
    description = "High performance logging in Round Robin Databases";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ehmry pSub ];
    mainProgram = "rrdtool";
  };
})

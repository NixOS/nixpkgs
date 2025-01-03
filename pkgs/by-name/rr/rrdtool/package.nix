{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  gettext,
  perl,
  pkg-config,
  libxml2,
  pango,
  cairo,
  groff,
  tcl,
  darwin,
}:

perl.pkgs.toPerlModule (
  stdenv.mkDerivation rec {
    pname = "rrdtool";
    version = "1.9.0";

    src = fetchFromGitHub {
      owner = "oetiker";
      repo = "rrdtool-1.x";
      rev = "v${version}";
      hash = "sha256-CPbSu1mosNlfj2nqiNVH14a5C5njkfvJM8ix3X3aP8E=";
    };

    # Fix darwin build
    patches = lib.optional stdenv.hostPlatform.isDarwin (fetchpatch {
      url = "https://github.com/oetiker/rrdtool-1.x/commit/98b2944d3b41f6e19b6a378d7959f569fdbaa9cd.diff";
      hash = "sha256-aP0rmDlILn6VC8Tg7HpRXbxL9+KD/PRTbXnbQ7HgPEg=";
    });

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];

    buildInputs =
      [
        gettext
        perl
        libxml2
        pango
        cairo
        groff
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        tcl
        darwin.apple_sdk.frameworks.ApplicationServices
      ];

    postInstall = ''
      # for munin and rrdtool support
      mkdir -p $out/${perl.libPrefix}
      mv $out/lib/perl/5* $out/${perl.libPrefix}
    '';

    meta = with lib; {
      homepage = "https://oss.oetiker.ch/rrdtool/";
      description = "High performance logging in Round Robin Databases";
      license = licenses.gpl2Only;
      platforms = platforms.linux ++ platforms.darwin;
      maintainers = with maintainers; [ pSub ];
    };
  }
)

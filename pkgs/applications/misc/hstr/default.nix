{ lib, stdenv, fetchFromGitHub, fetchpatch, readline, ncurses
, autoreconfHook, pkg-config, gettext }:

stdenv.mkDerivation rec {
  pname = "hstr";
  version = "2.3";

  src = fetchFromGitHub {
    owner  = "dvorka";
    repo   = "hstr";
    rev    = version;
    sha256 = "1chmfdi1dwg3sarzd01nqa82g65q7wdr6hrnj96l75vikwsg986y";
  };

  patches = [
    # pull pending upstream inclusion fix for ncurses-6.3:
    #  https://github.com/dvorka/hstr/pull/435
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/dvorka/hstr/commit/7fbd852c464ae3cfcd2f4fed9c62a21fb84c5439.patch";
      sha256 = "15f0ja4bsh4jnchcg0ray8ijpdraag7k07ss87a6ymfs1rg6i0jr";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ readline ncurses gettext ];

  configureFlags = [ "--prefix=$(out)" ];

  meta = {
    homepage = "https://github.com/dvorka/hstr";
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = with lib.platforms; linux ++ darwin;
  };

}

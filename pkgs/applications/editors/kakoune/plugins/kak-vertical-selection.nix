{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-vertical-selection";
  version = "2019-04-11";
  src = fetchFromGitHub {
    owner = "occivink";
    repo = "kakoune-vertical-selection";
    rev = "c420f8b867ce47375fac303886e31623669a42b7";
    sha256 = "13jdyd2j45wvgqvxdzw9zww14ly93bqjb6700zzxj7mkbiff6wsb";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r vertical-selection.kak $out/share/kak/autoload/plugins
  '';

  meta = with stdenv.lib;
  { description = "Select up and down lines that match the same pattern in Kakoune";
    homepage = "https://github.com/occivink/kakoune-vertical-selection";
    license = licenses.publicDoman;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}

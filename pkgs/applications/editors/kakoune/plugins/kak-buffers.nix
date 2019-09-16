{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-buffers";
  version = "2019-04-03";
  src = fetchFromGitHub {
    owner = "Delapouite";
    repo = "kakoune-buffers";
    rev = "3b35b23ac2be661a37c085d34dd04d066450f757";
    sha256 = "0f3g0v1sjinii3ig9753jjj35v2km4h9bcfw9xgzwz8b10d75bax";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r buffers.kak $out/share/kak/autoload/plugins
  '';

  meta = with stdenv.lib;
  { description = "Ease navigation between opened buffers in Kakoune";
    homepage = "https://github.com/Delapouite/kakoune-buffers";
    license = licenses.publicDoman;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}

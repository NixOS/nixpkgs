{ stdenv, git, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-powerline";
  version = "2019-07-23";
  src = fetchFromGitHub {
    owner = "andreyorst";
    repo = "powerline.kak";
    rev = "82b01eb6c97c7380b7da253db1fd484a5de13ea4";
    sha256 = "1480wp2jc7c84z1wqmpf09lzny6kbnbhiiym2ffaddxrd4ns9i6z";
  };

  configurePhase = ''
    substituteInPlace rc/modules/git.kak \
      --replace \'git\' \'${git}/bin/git\'
  '';

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/powerline
  '';

  meta = with stdenv.lib;
  { description = "Kakoune modeline, but with passion";
    homepage = "https://github.com/andreyorst/powerline.kak";
    license = licenses.publicDoman;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}

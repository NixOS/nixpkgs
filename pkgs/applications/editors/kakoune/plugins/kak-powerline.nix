{ stdenv, git, fetchFromGitHub, lib }:
stdenv.mkDerivation {
  name = "kak-powerline";
  version = "2020-08-22";
  src = fetchFromGitHub {
    owner = "jdugan6240";
    repo = "powerline.kak";
    rev = "d641b2cd8024f872bcda23f9256e7aff36da02ae";
    sha256 = "65948f5ef3ab2f46f6d186ad752665c251d887631d439949decc2654a67958a4";
  };

  configurePhase = ''
    substituteInPlace rc/modules/git.kak \
      --replace \'git\' \'${git}/bin/git\'
  '';

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/powerline
  '';

  meta = with lib;
  { description = "Kakoune modeline, but with passion";
    homepage = "https://github.com/jdugan6240/powerline.kak";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}

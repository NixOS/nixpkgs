{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "captive-browser";
  version = "2019-04-16";
  goPackagePath = name;

  src = fetchFromGitHub {
    owner  = "FiloSottile";
    repo   = "captive-browser";
    rev    = "08450562e58bf9564ee98ad64ef7b2800e53338f";
    sha256 = "17icgjg7h0xm8g4yy38qjhsvlz9pmlmj9kydz01y2nyl0v02i648";
  };

  meta = with lib; {
    description = "Dedicated Chrome instance to log into captive portals without messing with DNS settings";
    homepage = https://blog.filippo.io/captive-browser;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ volth ];
  };
}

{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation {
  name = "case.kak";
  version = "unstable-2020-04-06";

  src = fetchFromGitLab {
    owner = "FlyingWombat";
    repo = "case.kak";
    rev = "6f1511820aa3abfa118e0f856118adc8113e2185";
    sha256 = "002njrlwgakqgp74wivbppr9qyn57dn4n5bxkr6k6nglk9qndwdp";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc/case.kak $out/share/kak/autoload/plugins
  '';

  meta = with stdenv.lib; {
    description = "Ease navigation between opened buffers in Kakoune";
    homepage = "https://gitlab.com/FlyingWombat/case.kak";
    license = licenses.unlicense;
    maintainers = with maintainers; [ eraserhd ];
    platform = platforms.all;
  };
}


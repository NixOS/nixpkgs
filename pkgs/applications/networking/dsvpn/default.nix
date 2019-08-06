{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dsvpn";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = pname;
    rev = version;
    sha256 = "0vvvm664lkhnqyc03ylz8acz24dgpzyhwdlci5bc68s6wzsba549";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dsvpn

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A Dead Simple VPN";
    homepage = "https://github.com/jedisct1/dsvpn";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}

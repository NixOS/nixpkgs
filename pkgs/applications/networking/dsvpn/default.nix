{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dsvpn";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = pname;
    rev = version;
    sha256 = "1jl9b23s2glims09mb1sq01kaf10bfjsd3qsgk68mp5kvy9f3gj2";
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

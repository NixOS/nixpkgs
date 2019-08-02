{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dsvpn";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = pname;
    rev = version;
    sha256 = "1g747197zpg83ba9l9vxg8m3jv13wcprhnyr8asdxq745kzmynsr";
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

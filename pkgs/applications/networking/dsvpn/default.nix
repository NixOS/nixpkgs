{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dsvpn";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = pname;
    rev = version;
    sha256 = "1gbj3slwmq990qxsbsaxasi98alnnzv3adp6f8w8sxd4gi6qxhdh";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dsvpn

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Dead Simple VPN";
    homepage = "https://github.com/jedisct1/dsvpn";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
    mainProgram = "dsvpn";
  };
}

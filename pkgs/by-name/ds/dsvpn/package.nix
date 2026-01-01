{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "dsvpn";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dsvpn";
    rev = version;
    sha256 = "1gbj3slwmq990qxsbsaxasi98alnnzv3adp6f8w8sxd4gi6qxhdh";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dsvpn

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Dead Simple VPN";
    homepage = "https://github.com/jedisct1/dsvpn";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Dead Simple VPN";
    homepage = "https://github.com/jedisct1/dsvpn";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "dsvpn";
  };
}

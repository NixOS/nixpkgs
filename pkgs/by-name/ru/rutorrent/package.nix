{stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "rutorrent";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "Novik";
    repo = "ruTorrent";
    tag = "v${version}";
    hash = "sha256-QFxeOUtHIKKAhw8rQRYcGK0eay3dIWKNh4ST582EMYU=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r . $out/
    runHook postInstall;
  '';

  meta = with lib; {
    description = "Yet another web front-end for rTorrent";
    homepage = "https://github.com/Novik/ruTorrent";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

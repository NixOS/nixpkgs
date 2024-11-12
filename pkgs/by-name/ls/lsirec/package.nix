{ lib
, stdenv
, fetchFromGitHub
, python3
}:

stdenv.mkDerivation rec {
  pname = "lsirec";
  version = "unstable-2019-03-03";

  src = fetchFromGitHub {
    owner = "marcan";
    repo = "lsirec";
    rev = "2dfb6dc92649feb01a3ddcfd117d4a99098084f2";
    sha256 = "sha256-8v+KKjAJlJNpUT0poedRTQfPiDiwahrosXD35Bmh3jM=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    install -Dm755 'lsirec' "$out/bin/lsirec"
    install -Dm755 'sbrtool.py' "$out/bin/sbrtool"

    runHook postInstall
  '';

  meta = with lib; {
    description = "LSI SAS2008/SAS2108 low-level recovery tool for Linux";
    homepage = "https://github.com/marcan/lsirec";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ Luflosi ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}

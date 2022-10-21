{ lib, stdenv, fetchurl, libX11 }:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  arch = {
    "x86_64-linux" = "lx64";
    "i686-linux" = "lx86";
  }."${system}" or throwSystem;

in
stdenv.mkDerivation rec {
  pname = "minivmac";
  version = "36.04";

  src = fetchurl {
    url = "https://www.gryphel.com/d/minivmac/minivmac-36.04/minivmac-${version}.src.tgz";
    sha256 = "sha256-m3NDzsh3Ixd6ID5prTuvIPSbTo8DYZ42bEvycFFn36Q=";
  };

  buildInputs = [ libX11 ];

  buildPhase = ''
    $CC setup/tool.c -o setup_t
    ./setup_t -t ${arch} > setup.sh
    . setup.sh
    make
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 minivmac $out/bin/minivmac
    runHook postInstall
  '';

  meta = with lib; {
    description = "A miniature early Macintosh emulator";
    homepage = "https://www.gryphel.com/c/minivmac/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

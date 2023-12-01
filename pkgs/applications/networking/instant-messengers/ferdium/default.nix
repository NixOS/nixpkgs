{ lib, mkFranzDerivation, fetchurl, xorg, nix-update-script, stdenv }:

let
  arch = {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    amd64-linux_hash = "sha256-ZCyAz+XVp2NJVUuMWyv5ubjMaoYBsjPAye/1vO2jv/w=";
    arm64-linux_hash = "sha256-prdVwEn6eynzjLQ+aw2CS4PJ/JgG4QFKs9WDbzjV5oo=";
  }."${arch}-linux_hash";
in mkFranzDerivation rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "6.6.0";
  src = fetchurl {
    url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
    inherit hash;
  };

  extraBuildInputs = [ xorg.libxshmfence ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "All your services in one place built by the community";
    homepage = "https://ferdium.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ magnouvean ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    hydraPlatforms = [ ];
  };
}

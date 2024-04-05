{ lib, mkFranzDerivation, fetchurl, xorg, stdenv }:

let
  arch = {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash = {
    amd64-linux_hash = "sha256-RH8iHqJ0Nd3wkXmv/ZGX5JeWtxyJtVLVb0tz6tnkjrw=";
    arm64-linux_hash = "sha256-0gvkabuxRqkMeyZiOSyT6C7v767+uCrsXE8qk0y0mYM=";
  }."${arch}-linux_hash";
in
mkFranzDerivation rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "6.7.2";
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

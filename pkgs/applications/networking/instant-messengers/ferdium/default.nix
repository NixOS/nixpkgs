{
  lib,
  mkFranzDerivation,
  fetchurl,
  libxshmfence,
  stdenv,
}:

let
  arch =
    {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash =
    {
      amd64-linux_hash = "sha256-1jXo8MMk2EEkLo0n4ICmGJteKProLYKkMF//g63frHs=";
      arm64-linux_hash = "sha256-jYDGVZhL0bswowm1H/4aa35lNJalil6ymV34NQM5Gfc=";
    }
    ."${arch}-linux_hash";
in
mkFranzDerivation rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "7.1.1";
  src = fetchurl {
    url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
    inherit hash;
  };

  extraBuildInputs = [ libxshmfence ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "All your services in one place built by the community";
    homepage = "https://ferdium.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ magnouvean ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    hydraPlatforms = [ ];
  };
}

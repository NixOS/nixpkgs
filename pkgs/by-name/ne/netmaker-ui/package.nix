{ lib
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
}:
buildNpmPackage rec {
  pname = "netmaker-ui";
  version = "unstable-2024-01-26";

  src = fetchFromGitHub {
    owner = "gravitl";
    repo = "netmaker-ui-2";
    rev = "65058e5b1c945c19b406864bb0c721830821edfb";
    hash = "sha256-eoOPe7/o41uGyp5xkQ/Jrhz9LRaXh7O5jIJJmZuLJog=";
  };
  npmDepsHash = "sha256-cF0WQtX1P0ZmU8g4mUbdgKTFtTorURPLd2Qst8jxCZo=";

  installPhase = ''
    mkdir -p "$out/var"
    mv dist "$out/var/www"
  '';

  passthru.updateScript = nix-update-script {
    # TODO: disable after the commit lands in a release https://github.com/gravitl/netmaker-ui-2/commit/143ea10fd913cc01fcc9c82b088a37dccdaff438
    extraArgs = [ "--version=branch=develop" ];
  };
  meta = {
    description = "WireGuard automation from homelab to enterprise - web assets";
    homepage = "https://netmaker.io";
    changelog = "https://github.com/gravitl/netmaker-ui-2/-/releases/v${version}";
    license = lib.licenses.sspl;
    maintainers = with lib.maintainers; [ nazarewk ];
  };
}

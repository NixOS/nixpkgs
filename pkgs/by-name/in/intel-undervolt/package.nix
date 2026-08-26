{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-undervolt";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "kitsunyan";
    repo = "intel-undervolt";
    tag = finalAttrs.version;
    hash = "sha256-BxTNqXC+vG24/y8yZ/h1Ep4F8MwVdjsr5uo/BjuWULo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp intel-undervolt $out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Intel CPU undervolting and throttling configuration tool";
    homepage = "https://github.com/kitsunyan/intel-undervolt";
    mainProgram = "intel-undervolt";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ]; # It probably compiles for aaarch64-linux too, but what's the point?
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})

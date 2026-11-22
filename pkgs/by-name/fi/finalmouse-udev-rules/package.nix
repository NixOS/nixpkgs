{
  fetchFromGitHub,
  lib,
  stdenv,
  udevCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "finalmouse-udev-rules";
  version = "0-unstable-2026-10-16";

  src = fetchFromGitHub {
    owner = "teamfinalmouse";
    repo = "xpanel-linux-permissions";
    rev = "153b46312ef4cd2775d7e0c8b3e256f2c0398265";
    hash = "sha256-oDufIqFVW2rRRB8oWc36BZMYkeZvW5phJsbL9Ai7JaU=";
  };

  nativeBuildInputs = [ udevCheckHook ];
  doInstallCheck = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dpm644 $src/70-finalmouse.rules $out/lib/udev/rules.d/70-finalmouse.rules

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/teamfinalmouse/xpanel-linux-permissions";
    description = "udev rules that give NixOS permission to communicate with Finalmouse devices";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      emilia
    ];
  };
}

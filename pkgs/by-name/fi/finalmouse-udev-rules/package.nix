{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "finalmouse-udev-rules";
  version = "0-unstable-2025-08-15";

  src = fetchFromGitHub {
    owner = "teamfinalmouse";
    repo = "xpanel-linux-permissions";
    rev = "6b200ec39f1fa31edf6648f5ec3d5738c3770530";
    hash = "sha256-Bo8XBvrUlZe0eVQlNQGb0xuTb+wecipsHwLdZpK0dUQ=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dpm644 $src/99-finalmouse.rules $out/lib/udev/rules.d/70-finalmouse.rules

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/teamfinalmouse/xpanel-linux-permissions";
    description = "udev rules that give NixOS permission to communicate with Finalmouse mice";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      emilia
    ];
  };
}

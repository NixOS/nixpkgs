{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pfetch";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Un1q32";
    repo = "pfetch";
    tag = version;
    hash = "sha256-omI1Y1UKxSkg1QUd/GHHuGBwxfNOtxqYpzPbJdG7j3A=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin pfetch
  '';

  meta = {
    description = "Pretty system information tool written in POSIX sh";
    homepage = "https://github.com/Un1q32/pfetch";
    changelog = "https://github.com/Un1q32/pfetch/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ equirosa ];
    mainProgram = "pfetch";
  };
}

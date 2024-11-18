{
  lib,
  stdenv,
  nixosTests,
  fetchFromGitea,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icmptx";
  version = "0.2-unstable-2023-11-07";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jakkarth";
    repo = "icmptx";
    rev = "bffe9841f423da24f2d318773ec2f97db2805c0f";
    hash = "sha256-4p84bn9YgrbMqfl65P3KASvWWYIO0rX5q3mlBJbOiUE=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm 755 icmptx "$out/bin/icmptx"
    runHook postInstall
  '';

  strictDeps = true;

  passthru.tests = {
    inherit (nixosTests) icmptx;
  };

  meta = {
    description = "IP-over-ICMP tunnel";
    homepage = "https://codeberg.org/jakkarth/icmptx";
    license = with lib.licenses; [
      # The README.md and the header in some program files claim GPL2 or later but the LICENSE file contains the GPL3
      gpl2Plus
      gpl3Plus
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Luflosi ];
    mainProgram = "icmptx";
  };
})

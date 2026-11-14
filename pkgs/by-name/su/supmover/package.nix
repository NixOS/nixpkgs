{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "supmover";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "MonoS";
    repo = "SupMover";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AqxmCl3BH9+QpGyB/rMpuafhEDaIHHNy1gHOqlal1Fw=";
  };

  installPhase = ''
    install -Dm755 supmover $out/bin/supmover
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/MonoS/SupMover";
    description = "Shift timings and Screen Area of PGS/Sup subtitle";

    license = with lib.licenses; [
      agpl3Only
    ];

    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      claraphyll
    ];

    mainProgram = "supmover";
  };

  __structuredAttrs = true;
  strictDeps = true;
})

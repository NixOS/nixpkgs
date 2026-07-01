{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  dash,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mkroot-utils";
  version = "0.4.2";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "mkroot-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n8UGD5TQdtehYcz75zrt1ciQhA86x9Ljq+kiiJsNzQI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  patchPhase = ''
    runHook prePatch

    for f in CMakeLists.txt flash/flash.c pico/picoget.c; do
      substituteInPlace $f --replace-fail '/bin/ash' '${lib.getExe dash}'
    done

    runHook postPatch
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple utilities to extend RunC and \"mkroot\"";
    homepage = "https://gitlab.com/arpa2/mkroot-utils";
    # NO license yet? license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
  };
})

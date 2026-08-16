{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-japanese";
  version = "0-unstable-2023-08-02";

  src = fetchFromGitHub {
    owner = "gkovacs";
    repo = "rime-japanese";
    rev = "4c1e65135459175136f380e90ba52acb40fdfb2d";
    hash = "sha256-/mIIyCu8V95ArKo/vIS3qAiD8InUmk8fAF/wejxRxGw=";
  };

  installPhase = ''
    runHook preInstall

    install -D japanese.*.yaml -t $out/share/rime-data/

    runHook postInstall
  '';

  meta = {
    description = "Layout for typing in Japanese with RIME";
    homepage = "https://github.com/gkovacs/rime-japanese";

    # Awaiting upstream response (gkovacs/rime-japanese#6)
    # Packages are assumed unfree unless explicitly indicated otherwise
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.all;
  };
}

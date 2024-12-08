{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  pop-icon-theme,
  hicolor-icon-theme,
  nix-update-script,
}:
stdenvNoCC.mkDerivation {
  pname = "cosmic-icons";
  version = "1.0.0-alpha.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    rev = "epoch-1.0.0-alpha.3";
    hash = "sha256-7gWCRBiE+XJX1JSjopyPN4bIIgZih6ZKGVSA7wBq3i0=";
  };

  nativeBuildInputs = [ just ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  propagatedBuildInputs = [
    pop-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ a-kenji ];
  };
}

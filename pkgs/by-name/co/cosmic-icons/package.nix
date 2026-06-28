{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  pop-icon-theme,
  hicolor-icon-theme,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmic-icons";
  version = "1.1.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-QUTAYIQ6qAhjZK/9BZjJzTViECLUwO/MyaOqiRb1Ans=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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

  meta = {
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with lib.licenses; [
      cc-by-sa-40
    ];
    teams = [ lib.teams.cosmic ];
  };
})

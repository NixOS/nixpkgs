{ lib
, stdenvNoCC
, fetchFromGitHub
, just
, pop-icon-theme
, hicolor-icon-theme
, unstableGitUpdater
}:
stdenvNoCC.mkDerivation rec {
  pname = "cosmic-icons";
  version = "unstable-2023-11-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "1e328dacc117c21000a000a3170a801f467f3c2b";
    sha256 = "sha256-QmCHkqSPWfZhofh4ieJhl4yjt0R4J15+xElbszHS/4M=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ a-kenji ];
  };
}

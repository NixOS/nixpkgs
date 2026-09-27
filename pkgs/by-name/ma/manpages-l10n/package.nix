{
  stdenv,
  fetchFromGitLab,
  po4a,
  gettext,
  perl,
  nix-update-script,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "manpages-l10n";
  version = "4.30.2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "manpages-l10n-team";
    repo = "manpages-l10n";
    tag = finalAttrs.version;
    hash = "sha256-M1Br3+S6UEQUKV3kZOvkMat53khzdObQyTYX+E+lmtM=";
  };

  nativeBuildInputs = [
    po4a
    gettext
    perl
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;
  __structuredAttrs = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "manpages-l10n";
    description = "Translation of manpages";
    homepage = "https://manpages-l10n-team.pages.debian.net/manpages-l10n/";
    changelog = "https://salsa.debian.org/manpages-l10n-team/manpages-l10n/-/releases/${finalAttrs.version}";
    license = [ lib.licenses.gpl3Only ];
    maintainers = with lib.maintainers; [ sanae6 ];
  };
})

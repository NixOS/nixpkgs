{
  lib,
  consult,
  embark,
  fetchFromGitHub,
  forge,
  gh,
  markdown-mode,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "consult-gh";
  version = "1.0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "armindarvish";
    repo = "consult-gh";
    rev = "e12b24e68116ac6c171d628c547c017458d6aa2b";
    hash = "sha256-skZkpYUWncGUf9k0IfEq3LAqDXHIfCJJ3p3b3ey+Rks=";
  };

  packageRequires = [
    consult
    embark
    forge
    markdown-mode
  ];

  propagatedUserEnvPkgs = [ gh ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/armindarvish/consult-gh";
    description = "GitHub CLI client inside GNU Emacs using Consult";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

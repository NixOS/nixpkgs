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
  version = "1.0-unstable-2024-08-11";

  src = fetchFromGitHub {
    owner = "armindarvish";
    repo = "consult-gh";
    rev = "640d4b9c71aa6dfff4f29c0207cc02316f1d61c8";
    hash = "sha256-hFHex4cUAP1U5aK1bfa+va1jiWS8tRqtnMGxr17NWio=";
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

{
  lib,
  avy,
  bind-key,
  cl-lib,
  company,
  company-quickhelp,
  default-text-scale,
  f,
  fetchFromGitHub,
  helm,
  json-rpc-server,
  melpaBuild,
  nav-flash,
  porthole,
  unstableGitUpdater,
  yasnippet,
}:

melpaBuild {
  pname = "voicemacs";
  version = "0-unstable-2022-02-16";

  src = fetchFromGitHub {
    owner = "jcaw";
    repo = "voicemacs";
    rev = "d91de2a31c68ab083172ade2451419d6bd7bb389";
    hash = "sha256-/MBB2R9/V0aYZp15e0vx+67ijCPp2iPlgxe262ldmtc=";
  };

  patches = [
    ./0000-add-missing-require.patch
  ];

  packageRequires = [
    avy
    bind-key
    cl-lib
    company
    company-quickhelp
    default-text-scale
    f
    helm
    json-rpc-server
    nav-flash
    porthole
    yasnippet
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/jcaw/voicemacs/";
    description = "Set of utilities for controlling Emacs by voice";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

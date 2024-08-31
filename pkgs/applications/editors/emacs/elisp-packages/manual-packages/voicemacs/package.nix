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
  el-patch,
}:

melpaBuild {
  pname = "voicemacs";
  version = "0-unstable-2024-01-03";

  src = fetchFromGitHub {
    owner = "jcaw";
    repo = "voicemacs";
    rev = "d93f15d855d61f78827d78c9ca3508766266366c";
    hash = "sha256-D/5+3SgECEb7A8qQqsAV1TQr+lA8EyOjf6NesnV2gos=";
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
    el-patch
  ];

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/jcaw/voicemacs/";
    description = "Set of utilities for controlling Emacs by voice";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

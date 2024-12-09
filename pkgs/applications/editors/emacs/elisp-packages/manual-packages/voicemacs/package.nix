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
  version = "0-unstable-2024-10-11";

  src = fetchFromGitHub {
    owner = "jcaw";
    repo = "voicemacs";
    rev = "d8dade06a48994ff04f48e1177eed4e9243cbcb1";
    hash = "sha256-kCuwjMl3pPWQNoXEl+oK6YoOLpk8kazLb69RwiGltAA=";
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

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/jcaw/voicemacs/";
    description = "Set of utilities for controlling Emacs by voice";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}

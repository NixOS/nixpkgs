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
  yasnippet,
  el-patch,
}:

melpaBuild {
  pname = "voicemacs";
  version = "0-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "jcaw";
    repo = "voicemacs";
    rev = "fb6133f59d3062a0cb2396353d9a1edd2af4750a";
    hash = "sha256-7JF6c5T+Dl3/S3zMHwvf7lsnsPWoZStE1FiVobJHgyI=";
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

  meta = {
    homepage = "https://github.com/jcaw/voicemacs/";
    description = "Set of utilities for controlling Emacs by voice";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}

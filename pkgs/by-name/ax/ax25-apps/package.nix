{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libax25,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "ax25-apps";
  version = "0.0.8-rc5-unstable-2021-05-13";

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libax25
    ncurses
  ];

  # src from linux-ax25.in-berlin.de remote has been
  # unreliable, pointing to github mirror from the radiocatalog
  src = fetchFromGitHub {
    owner = "radiocatalog";
    repo = "ax25-apps";
    rev = "afc4a5faa01a24c4da1d152b901066405f36adb6";
    hash = "sha256-RLeFndis2OhIkJPLD+YfEUrJdZL33huVzlHq+kGq7dA=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var/lib"
    "--program-transform-name=s@^call$@ax&@;s@^listen$@ax&@"
  ];

  meta = {
    description = "AX.25 ham radio applications";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.linux;
  };
}

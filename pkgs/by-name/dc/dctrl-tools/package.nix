{
  lib,
  stdenv,
  fetchFromGitLab,
  gettext,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dctrl-tools";
  version = "2.24-2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "dctrl-tools";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-QTKOoZbsYgWnU0bapVE/CjiI20g7ZhB2MhEPd1z/wNE=";
  };

  nativeBuildInputs = [
    gettext
    perlPackages.Po4a
  ];

  preConfigure = ''
    export CFLAGS="-g -O2 -Wall -Wextra" # We remove -Werror from the flags
    substituteInPlace GNUmakefile --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Command-line tools to process Debian package information";
    homepage = "https://salsa.debian.org/debian/dctrl-tools";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ skohtv ];
  };
})

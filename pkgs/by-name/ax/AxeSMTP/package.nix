{
  lib,
  stdenv,
  fetchFromGitLab,
  Pavlov,
  arpa2cm,
  arpa2common,
  cmake,
  doxygen,
  graphviz,
  libev,
  openssl,
  python3,
  quickmem,
  ragel,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "AxeSMTP";
  version = "1.7.1";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "AxeSMTP";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rdICjs9bJPyYhgifq055h0vbp4wD1GFRwZRkhiANT+o=";
  };


  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    Pavlov
    arpa2common
    cmake
    doxygen
    graphviz
    python3
    ragel
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    libev
    openssl
    quickmem
  ];

  prePatch = ''
    sed -i -e 's/#include <stdbool.h>/#include <stdbool.h>\n#include <stdio.h>/' src/command.rl
    patchShebangs test
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toolkit, including applications, for modifying SMTP traffic while passing through";
    homepage = "https://gitlab.com/arpa2/AxeSMTP";
    # NO license yet? license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
  };
})

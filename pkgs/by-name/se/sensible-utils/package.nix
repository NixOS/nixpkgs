{
  stdenv,
  lib,
  fetchFromGitLab,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "sensible-utils";
  version = "0.0.24";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "sensible-utils";
    rev = "debian/${version}";
    sha256 = "sha256-omdg5df/TxURarrqawsB3+B85siDJxDaex/2rx5csXI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin

    cp sensible-browser sensible-editor sensible-pager sensible-terminal $out/bin/
  '';

  meta = with lib; {
    description = "Collection of utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager";
    longDescription = ''
      The specific utilities included are:
      - sensible-browser
      - sensible-editor
      - sensible-pager
    '';
    homepage = "https://salsa.debian.org/debian/sensible-utils";
    changelog = "https://salsa.debian.org/debian/sensible-utils/-/tags";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.unix;
  };
}

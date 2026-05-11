{
  stdenv,
  lib,
  fetchFromGitLab,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sensible-utils";
  version = "0.0.26";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "sensible-utils";
    rev = "debian/${finalAttrs.version}";
    sha256 = "sha256-vxzCICkF3KDBe+IIZ63JMiZmfHOllHf1Xtw/vWaimc8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin

    cp sensible-browser sensible-editor sensible-pager sensible-terminal $out/bin/
  '';

  meta = {
    description = "Collection of utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager";
    longDescription = ''
      The specific utilities included are:
      - sensible-browser
      - sensible-editor
      - sensible-pager
    '';
    homepage = "https://salsa.debian.org/debian/sensible-utils";
    changelog = "https://salsa.debian.org/debian/sensible-utils/-/tags";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = lib.platforms.unix;
  };
})

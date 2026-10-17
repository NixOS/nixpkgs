{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.7.10";
  pname = "mwic";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${finalAttrs.version}/mwic-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-dmIHPehkxpSb78ymVpcPCu4L41coskrHQOg067dprOo=";
  };

  makeFlags = [ "PREFIX=\${out}" ];

  nativeBuildInputs = [
    python3Packages.wrapPython
  ];

  propagatedBuildInputs = with python3Packages; [
    pyenchant
    regex
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = "http://jwilk.net/software/mwic";
    description = "Spell-checker that groups possible misspellings and shows them in their contexts";
    mainProgram = "mwic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})

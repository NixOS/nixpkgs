{
  fetchFromGitHub,
  lib,
  vimUtils,
  writableTmpDirAsHomeHook,
  macaulay2,
}:
vimUtils.buildVimPlugin {
  pname = "macaulay2";
  inherit (macaulay2) version;

  # we don't need the whole (rather large) repo
  src = fetchFromGitHub {
    inherit (macaulay2.src) repo owner tag;
    rootDir = "M2/Macaulay2/editors/vim";
    hash = "sha256-F/Vo8tOA/ZRczZJiUHY0Sr3ibRXHBLtqqSYIamqjk18=";
  };

  postPatch = ''
    substituteInPlace "ftplugin/m2.vim" \
      --replace-fail "'M2'" "'${lib.getExe macaulay2}'"
  '';

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    ${lib.getExe macaulay2} <<EOF
      needsPackage "Style"
      generateGrammar("dict/m2.vim.dict", demark_" ")
      generateGrammar("syntax/m2.vim", demark_" ")
    EOF
  '';

  meta = {
    inherit (macaulay2.meta) maintainers platforms;
    description = "Syntax highlighting and key mappings to send code to a running Macaulay2 session.";
    homepage = "https://github.com/Macaulay2/M2/tree/stable/M2/Macaulay2/editors/vim";
    license =
      with lib.licenses;
      OR [
        publicDomain
        gpl2Plus
      ];
  };
}

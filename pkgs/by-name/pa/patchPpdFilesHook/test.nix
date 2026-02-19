{
  lib,
  replaceVars,
  diffutils,
  stdenv,
  patchPpdFilesHook,
}:

let
  inherit (lib.meta) getExe';

  input = replaceVars ./test.ppd {
    keep = "cmp";
    patch = "cmp";
    pathkeep = "/bin/cmp";
    pathpatch = "/bin/cmp";
  };

  output = replaceVars ./test.ppd {
    keep = "cmp";
    patch = getExe' diffutils "cmp";
    pathkeep = "/bin/cmp";
    pathpatch = getExe' diffutils "cmp";
  };
in

stdenv.mkDerivation {
  name = "${patchPpdFilesHook.name}-test";
  buildInputs = [ diffutils ];
  nativeBuildInputs = [
    diffutils
    patchPpdFilesHook
  ];
  dontUnpack = true;
  dontInstall = true;
  ppdFileCommands = [ "cmp" ];
  preFixup = ''
    install -D "${input}" "${placeholder "out"}/share/cups/model/test.ppd"
    install -D "${input}" "${placeholder "out"}/share/ppd/test.ppd"
  '';
  postFixup = ''
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/cups/model/test.ppd"
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/ppd/test.ppd"
  '';
}

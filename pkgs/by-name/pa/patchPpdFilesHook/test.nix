{
  replaceVars,
  diffutils,
  stdenv,
  patchPpdFilesHook,
}:

let
  input = replaceVars ./test.ppd {
    keep = "cmp";
    patch = "cmp";
    pathkeep = "/bin/cmp";
    pathpatch = "/bin/cmp";
  };

  output = replaceVars ./test.ppd {
    keep = "cmp";
    patch = "${diffutils}/bin/cmp";
    pathkeep = "/bin/cmp";
    pathpatch = "${diffutils}/bin/cmp";
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
    install -D "${input}" "${placeholder "out"}/share/ppds/test.ppd"
  '';
  postFixup = ''
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/cups/model/test.ppd"
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/ppds/test.ppd"
  '';
}

{
<<<<<<< HEAD
  lib,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  replaceVars,
  diffutils,
  stdenv,
  patchPpdFilesHook,
}:

let
<<<<<<< HEAD
  inherit (lib.meta) getExe';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  input = replaceVars ./test.ppd {
    keep = "cmp";
    patch = "cmp";
    pathkeep = "/bin/cmp";
    pathpatch = "/bin/cmp";
  };

  output = replaceVars ./test.ppd {
    keep = "cmp";
<<<<<<< HEAD
    patch = getExe' diffutils "cmp";
    pathkeep = "/bin/cmp";
    pathpatch = getExe' diffutils "cmp";
=======
    patch = "${diffutils}/bin/cmp";
    pathkeep = "/bin/cmp";
    pathpatch = "${diffutils}/bin/cmp";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    install -D "${input}" "${placeholder "out"}/share/ppd/test.ppd"
  '';
  postFixup = ''
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/cups/model/test.ppd"
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/ppd/test.ppd"
=======
    install -D "${input}" "${placeholder "out"}/share/ppds/test.ppd"
  '';
  postFixup = ''
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/cups/model/test.ppd"
    diff --color --report-identical-files "${output}" "${placeholder "out"}/share/ppds/test.ppd"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';
}

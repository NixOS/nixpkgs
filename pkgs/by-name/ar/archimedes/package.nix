{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "archimedes";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://gnu/archimedes/archimedes-${version}.tar.gz";
    sha256 = "0jfpnd3pns5wxcxbiw49v5sgpmm5b4v8s4q1a5292hxxk2hzmb3z";
  };

  patches = [
    # Pull patch pending upstream inclusion to support c99 toolchains:
    #   https://savannah.gnu.org/bugs/index.php?62703
    (fetchpatch {
      name = "c99.patch";
      url = "https://savannah.gnu.org/bugs/download.php?file_id=53393";
      sha256 = "1xmy1w4ln1gynldk3srdi2h0fxpx465dsa1yxc3rzrrjpxh6087f";
    })
  ];

  meta = {
    description = "GNU package for semiconductor device simulations";
    mainProgram = "archimedes";
    homepage = "https://www.gnu.org/software/archimedes";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
  };
}

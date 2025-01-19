{
  faust,
  csound,
}:

faust.wrapWithBuildEnv {

  baseName = "faust2csound";

  propagatedBuildInputs = [
    csound
  ];

  # faust2csound generated .cpp files have
  #   #include "csdl.h"
  # but that file is in the csound/ subdirectory
  preFixup = ''
    NIX_CFLAGS_COMPILE="$(printf '%s' "$NIX_CFLAGS_COMPILE" | sed 's%${csound}/include%${csound}/include/csound%')"
  '';

}

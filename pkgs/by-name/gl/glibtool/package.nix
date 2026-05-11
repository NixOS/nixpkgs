{ libtool }:

libtool.overrideAttrs {
  pname = "glibtool";
  meta.mainProgram = "glibtool";
  configureFlags = [ "--program-prefix=g" ];
}

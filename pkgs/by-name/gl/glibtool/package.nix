{ libtool }:

libtool.overrideAttrs (finalAttrs: prevAttrs: {
  pname = "glibtool";
  meta.mainProgram = "glibtool";
  configureFlags = [ "--program-prefix=g" ];
})

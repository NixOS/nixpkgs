{
  julec,
  clangStdenv,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "hello-jule";
  inherit (julec) version;

  src = ./hello-jule;

  nativeBuildInputs = [ julec.hook ];

  doCheck = true;

  meta = {
    inherit (julec.meta) platforms;
  };
})

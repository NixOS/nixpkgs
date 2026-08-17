{
  clangStdenv,
  objfw,
  writeTextDir,
}:

clangStdenv.mkDerivation {
  name = "ObjFW test";
  buildInputs = [ objfw ];

  src = writeTextDir "helloworld.m" ''
    #import <ObjFW/ObjFW.h>
    int main() {
        OFLog(@"Hello world from objc");
        return 0;
    }
  '';

  buildPhase = ''
    runHook preBuild
    clang -o testbinary \
            -x objective-c -Xclang \
            -fobjc-runtime=objfw \
            -funwind-tables \
            -fconstant-string-class=OFConstantString \
            -Xclang -fno-constant-cfstrings \
            helloworld.m \
            -lobjfw -lobjfwrt
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ./testbinary
    runHook postCheck
  '';
  doCheck = true;

  installPhase = ''
    runHook preInstall
    touch $out
    runHook postInstall
  '';
}

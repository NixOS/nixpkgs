{
  autoconf,
  autogen,
  automake,
  clangStdenv,
  fetchfossil,
  lib,
  objfw,
  writeTextDir,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.2.3";

  src = fetchfossil {
    url = "https://objfw.nil.im/home";
    rev = "${finalAttrs.version}-release";
    hash = "sha256-qYZkuJ57/bhvKukXECHC38ooDQ8GE2vbuvY/bvH4ZVY=";
  };

  nativeBuildInputs = [
    automake
    autogen
    autoconf
  ];

  preConfigure = "./autogen.sh";
  configureFlags = [
    "--without-tls"
  ];

  doCheck = true;

  passthru.tests = {
    build-hello-world = clangStdenv.mkDerivation {
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
    };
  };

  meta = {
    description = "A portable framework for the Objective-C language";
    homepage = "https://objfw.nil.im";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})

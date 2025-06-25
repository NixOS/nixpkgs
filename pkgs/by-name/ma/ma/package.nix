{
  lib,
  stdenv,
  tclPackages,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "ma";
  version = "11";

  src = fetchurl {
    url = "https://web.archive.org/web/20250511210225/http://call-with-current-continuation.org/ma/ma.tar.gz";
    hash = "sha256-1UVxXbN2jSNm13BjyoN3jbKtkO3DUEEHaDOC2Ibbxf4=";
  };

  postPatch = ''
    substituteInPlace ./build --replace-fail gcc ${lib.getExe stdenv.cc}
  '';

  buildInputs = [
    tclPackages.tk
  ];

  buildPhase = ''
    runHook preBuild
    ./build
    for f in B ma ma-eval; do
      substituteInPlace $f --replace-fail \
        'set exec_prefix ""' "set exec_prefix \"$out/bin/\""
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin \
      B awd ma ma-eval plumb pty win
    runHook postInstall
  '';

  meta = {
    description = "minimalistic variant of the Acme editor";
    homepage = "http://call-with-current-continuation.org/ma/ma.html";
    mainProgram = "ma";
    maintainers = with lib.maintainers; [ ehmry ];
    # Per the README:
    # > All of MA's source code is hereby placed in the public domain
    license = lib.licenses.publicDomain;
    inherit (tclPackages.tk.meta) platforms;
  };
}

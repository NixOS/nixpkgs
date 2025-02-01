{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (self: {
  pname = "CLProver++";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "PaulGainer";
    repo = "CLProverPlusPlus";
    rev = "66bf6dc19d77094cc06eac3f30a3630ba830ac86";
    sha256 = "sha256-UZ5e11wGuKyVrG+7hZJY6OmN6Y1mg43xPuvXPRVNKNw=";
  };

  postPatch = ''
    sed -i 's/\(TARGET_OS *:= *\)[^ ]+/\1${
      if stdenv.targetPlatform.isWindows then "WINDOWS" else "LINUX"
    }/g' Makefile
    sed -i 's/-m64/${
      if stdenv.targetPlatform.isAarch then
        "-march=${stdenv.targetPlatform.gcc.arch}"
      else if stdenv.targetPlatform.is32bit then
        "-m32"
      else
        "-m64"
    }/g' Makefile
  '';

  preBuild = ''
    mkdir bin
  '';

  makeFlags = [
    "CC=${lib.getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}g++"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r bin $out/

    mkdir -p $out/share/${self.pname}
    cp -r examples $out/share/${self.pname}/examples

    runHook postInstall
  '';

  meta = {
    description = "Ordered resolution based theorem prover for Coalition Logic";
    homepage = "https://cgi.csc.liv.ac.uk/~ullrich/CLProver++/";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = with lib.platforms; linux ++ windows;
    license = lib.licenses.gpl3;
    mainProgram = if stdenv.targetPlatform.isWindows then "CLProver++.exe" else "CLProver++";
  };
})

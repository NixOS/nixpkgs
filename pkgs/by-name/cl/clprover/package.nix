{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "CLProver++";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "PaulGainer";
    repo = "CLProverPlusPlus";
    rev = "66bf6dc19d77094cc06eac3f30a3630ba830ac86";
    sha256 = "sha256-UZ5e11wGuKyVrG+7hZJY6OmN6Y1mg43xPuvXPRVNKNw=";
  };

  configurePhase = lib.optional stdenv.hostPlatform.isCygwin ''
    runHook preConfigure

    sed -i 's/\(TARGET_OS *:= *\)LINUX/\1WINDOWS/g' Makefile

    runHook postConfigure
  '';

  preBuild = ''
    mkdir bin
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 bin/${pname} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -r examples $out/share/${pname}/examples

    runHook postInstall
  '';

  meta = with lib; {
    description = "An ordered resolution based theorem prover for Coalition Logic.";
    homepage = "https://cgi.csc.liv.ac.uk/~ullrich/CLProver++/";
    maintainers = with maintainers; [ mgttlinger ];
    platforms = with platforms; linux ++ windows;
    broken = stdenv.hostPlatform.isWindows; # g++ is missing there in my tests but a gcc input is also not available there.
    license = licenses.gpl3;
  };
}

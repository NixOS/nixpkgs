{ lib, buildDubPackage, fetchFromGitHub, clang, ldc, which }:
buildDubPackage rec {
  pname = "dstep";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "jacob-carlborg";
    repo = "dstep";
    rev = "v${version}";
    hash = "sha256-ZFz2+GtBk3StqXo/9x47xrDFdz5XujHR62hj0p3AjcY=";
  };

  dubLock = ./dub-lock.json;

  nativeBuildInputs = [ ldc which clang ];

  preConfigure = ''
    ./configure --llvm-path ${lib.getLib clang.cc}
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/dstep -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool for converting C and Objective-C headers to D modules";
    homepage = "https://github.com/jacob-carlborg/dstep";
    license = licenses.boost;
    mainProgram = "dstep";
    maintainers = with maintainers; [ imrying ];
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "jtc";
  version = "1.76";

  src = fetchFromGitHub {
    owner = "ldn-softdev";
    repo = "jtc";
    rev = version;
    sha256 = "sha256-VATRlOOV4wBInLOm9J0Dp2vhtL5mb0Yxdl/ya0JiqEU=";
  };

  patches = [
    # Fix building with Clang. Removing with next release.
    (fetchpatch {
      url = "https://github.com/ldn-softdev/jtc/commit/92a5116e5524c0b6d2f539db7b5cc9fdd7c5b8ab.patch";
      sha256 = "sha256-AAvDH0XsT8/CAguG611/odg0m1HR+veC0jbAw6KLHLM=";
    })
  ];

  buildPhase = ''
    runHook preBuild

    $CXX -o jtc -Wall -std=gnu++14 -Ofast -pthread -lpthread jtc.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin jtc

    runHook postInstall
  '';

  meta = with lib; {
    description = "JSON manipulation and transformation tool";
    mainProgram = "jtc";
    homepage = "https://github.com/ldn-softdev/jtc";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

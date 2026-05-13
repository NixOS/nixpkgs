{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "insert-dylib";
  version = "0-unstable-2016-08-28";

  src = fetchFromGitHub {
    owner = "Tyilo";
    repo = "insert_dylib";
    rev = "c8beef66a08688c2feeee2c9b6eaf1061c2e67a9";
    hash = "sha256-yq+NRU+3uBY0A7tRkK2RFKVb0+XtWy6cTH7va4BH4ys=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p Products/Release
    $CC -o Products/Release/insert_dylib insert_dylib/main.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 Products/Release/insert_dylib -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Command line utility for inserting a dylib load command into a Mach-O binary";
    homepage = "https://github.com/tyilo/insert_dylib";
    license = lib.licenses.unfree; # no license specified
    mainProgram = "insert_dylib";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.darwin;
  };
}

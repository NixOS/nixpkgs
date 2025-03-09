{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
}:

let
  privateFrameworks = "/Library/Apple/System/Library/PrivateFrameworks";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ios-deploy";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "ios-control";
    repo = "ios-deploy";
    rev = finalAttrs.version;
    hash = "sha256-TVGC+f+1ow3b93CK3PhIL70le5SZxxb2ug5OkIg8XCA=";
  };

  buildPhase = ''
    runHook preBuild

    awk '{ print "\""$0"\\n\""}' src/scripts/lldb.py >> src/ios-deploy/lldb.py.h
    clang src/ios-deploy/ios-deploy.m \
      -framework Foundation \
      -F${privateFrameworks} -framework MobileDevice \
      -o ios-deploy

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ios-deploy $out/bin/ios-deploy

    runHook postInstall
  '';

  __impureHostDeps = [
    privateFrameworks
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Install and debug iPhone apps from the command line, without using Xcode";
    homepage = "https://github.com/ios-control/ios-deploy";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ios-deploy";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.darwin;
  };
})

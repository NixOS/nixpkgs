{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "multipart-parser-c";
  version = "0-unstable-2015-12-14";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "iafonov";
    repo = "multipart-parser-c";
    rev = "772639cf10db6d9f5a655ee9b7eb20b815fab396";
    hash = "sha256-tJsSN+MLMg3gtNLoF6ChRaiFKuRVnsmH4zk4JPcw2RQ=";
  };

  buildPhase = ''
    runHook preBuild
    make solib
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv lib*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/

    mkdir -p $out/include
    mv *.h $out/include/

    runHook postInstall
  '';

  meta = {
    description = "HTTP multipart parser implemented in C";
    homepage = "https://github.com/iafonov/multipart-parser-c";
    license = lib.licenses.mit;
  };

}

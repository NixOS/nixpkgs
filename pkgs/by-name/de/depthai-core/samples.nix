{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samples";
  version = "unstable-2025-01-23";

  src = fetchFromGitHub {
    owner = "oliora";
    repo = "samples";
    rev = "58dead450bdac418fc55dfc512b8411556f51c0e";
    sha256 = "sha256-9rLG4Kg+YrGUCeIUys52oNQ+eTTycHtO81u9SQiOxEE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/

    cp spimpl.h $out/include/

    runHook postInstall
  '';

  meta = {
    description = "Header-only C++ library for various samples";
    homepage = "https://github.com/oliora/samples";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})

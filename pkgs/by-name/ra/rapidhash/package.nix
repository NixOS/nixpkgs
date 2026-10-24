{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rapidhash";
  version = "3";
  src = fetchFromGitHub {
    owner = "Nicoshev";
    repo = "rapidhash";
    tag = "rapidhash_v${finalAttrs.version}";
    hash = "sha256-3J5/R3TcIqMkhst6sAxS3X/ZC7C5Jl60nPPMVyaugzc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 *.h -t $out/include/rapidhash
    runHook postInstall
  '';

  meta = {
    description = "Very fast, high quality, platform-independent hashing algorithm libraries for C++";
    homepage = "https://github.com/Nicoshev/rapidhash/";
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.jackr ];
  };
})

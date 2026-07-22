{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lialg";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "sgorsten";
    repo = "linalg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2I+sJca0tf/CcuoqaldfwPVRrzNriTXO60oHxsFQSnE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 linalg.h -t $out/include

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Single-header, public domain, short vector math library for C++";
    homepage = "https://github.com/sgorsten/linalg";
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.all;
  };
})

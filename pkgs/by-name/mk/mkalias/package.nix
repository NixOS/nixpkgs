{ lib
, stdenv
, fetchFromGitHub
, cmake
, darwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkalias";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "vs49688";
    repo = "mkalias";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L6bgCJ0fdiWmtlgTzDmTenTMP74UFUEqiDmE1+gg3zw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    darwin.apple_sdk.frameworks.Foundation
  ];

  installPhase = ''
    runHook preInstall

    install -D mkalias $out/bin/mkalias

    runHook postInstall
  '';

  meta = {
    description = "Quick'n'dirty tool to make APFS aliases";
    homepage = "https://github.com/vs49688/mkalias";
    license = lib.licenses.mit;
    mainProgram = "mkalias";
    maintainers = with lib.maintainers; [ zane emilytrau ];
    platforms = lib.platforms.darwin;
  };
})

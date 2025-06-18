{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readexe";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "segin";
    repo = "readexe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CT1EZQ3t7+5onmcUz5yGxDI24dyelUwYZFcL8YWZgPw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Reads out structural information on Microsoft .exe formats";
    homepage = "https://github.com/segin/readexe";
    license = with licenses; [
      isc
      bsd3
    ];
    maintainers = with maintainers; [ evils ];
    mainProgram = "readexe";
  };
})

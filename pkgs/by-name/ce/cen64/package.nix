{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGL,
  libiconv,
  libX11,
  openal,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cen64";
  version = "0.3-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "n64dev";
    repo = "cen64";
    rev = "e0641c8452a3ae8edcd2bf4e46794bb4eaafc076";
    hash = "sha256-PpaD3hgksPD729LyFm7+ID8i+x3yZ0f+S11eSQyoB64=";
  };

  # fix build with gcc14:
  # https://github.com/n64dev/cen64/pull/191/commits/f13bdf94c00a9da3b152ed9fe20001e240215b96
  patches = [ ./cast-mi_regs-callbacks.patch ];

  strictDeps = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libGL
    libiconv
    libX11
    openal
  ];

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.meta.mainProgram} \
      --target-directory=$out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Cycle-Accurate Nintendo 64 Emulator";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/n64dev/cen64";
    maintainers = with lib.maintainers; [ _414owen ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cen64";
  };
})

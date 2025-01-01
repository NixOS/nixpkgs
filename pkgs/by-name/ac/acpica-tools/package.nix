{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "acpica-tools";
  version = "R2024_12_12";

  src = fetchFromGitHub {
    owner = "acpica";
    repo = "acpica";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-vxiWYUAEk54F1M0WrrMTHZ4DNJxxT/GaXetd5LjE808=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  buildFlags = [
    "acpibin"
    "acpidump"
    "acpiexamples"
    "acpiexec"
    "acpihelp"
    "acpisrc"
    "acpixtract"
    "iasl"
  ];

  env.NIX_CFLAGS_COMPILE = toString ([
    "-O3"
  ]);

  enableParallelBuilding = true;

  # i686 builds fail with hardening enabled (due to -Wformat-overflow). Disable
  # -Werror altogether to make this derivation less fragile to toolchain
  # updates.
  NOWERROR = "TRUE";

  # We can handle stripping ourselves.
  # Unless we are on Darwin. Upstream makefiles degrade coreutils install to cp if _APPLE is detected.
  INSTALLFLAGS = lib.optionals (!stdenv.hostPlatform.isDarwin) "-m 555";

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.acpica.org/";
    description = "ACPICA Tools";
    license = with lib.licenses; [
      iasl
      gpl2Only
      bsd3
    ];
    maintainers = with lib.maintainers; [
      tadfisher
      felixsinger
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

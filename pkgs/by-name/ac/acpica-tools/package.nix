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
  version = "20260408";

  src = fetchFromGitHub {
    owner = "acpica";
    repo = "acpica";
    tag = finalAttrs.version;
    hash = "sha256-m6xugPmjwa/67IB8GiOd0Rasfry/vMbX0lC6OIEbyvU=";
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

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-O3"
    ];

    # ACPICA emits packed structs that produce unaligned pointers. Apple's
    # arm64 linker rejects these under chained fixups; opt back into the
    # legacy fixup format so the link succeeds.
    NIX_LDFLAGS = lib.optionalString (
      stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
    ) "-no_fixup_chains";

    # i686 builds fail with hardening enabled (due to -Wformat-overflow). Disable
    # -Werror altogether to make this derivation less fragile to toolchain
    # updates.
    NOWERROR = "TRUE";

    # We can handle stripping ourselves.
    # Unless we are on Darwin. Upstream makefiles degrade coreutils install to cp if _APPLE is detected.
    INSTALLFLAGS = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-m 555";
  };

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.acpica.org/";
    description = "ACPICA Tools";
    changelog = "https://github.com/acpica/acpica/releases/tag/${finalAttrs.version}";
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

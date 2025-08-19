{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  # Build the FMUs following the latest FMI standard
  FMIVersion ? 3,
}:

# C.f. <https://fmi-standard.org/>
assert lib.asserts.assertMsg (
  FMIVersion >= 1 && FMIVersion <= 3
) "FMIVersion must be a valid FMI specification standard: 1, 2, or 3; not ${toString FMIVersion}";

# NB: this derivation does not package the fmusim executables, only
# the FMUs.
stdenv.mkDerivation (finalAttrs: {
  pname = "reference-fmus";
  version = "0.0.39";
  src = fetchFromGitHub {
    owner = "modelica";
    repo = "reference-fmus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3bjqfEyPhqVrJOHHhniacyUAo82InCd6LLx3tyC8DYg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFMI_VERSION=${toString FMIVersion}"
    (lib.cmakeBool "WITH_FMUSIM" false)
  ];
  CFLAGS = lib.optionalString (FMIVersion == 3) "-Wno-stringop-truncation";

  meta = {
    # CMakeLists.txt explicitly states support for aarch64-darwin, but
    # the build fails in a Nix environment. C.f.
    # <https://github.com/NixOS/nixpkgs/pull/397658#issuecomment-2851958172>.
    broken = with stdenv.hostPlatform; isAarch64 && isDarwin;
    description = "Functional Mock-up Units for development, testing and debugging";
    homepage = "https://github.com/modelica/Reference-FMUs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tmplt ];
    platforms = lib.platforms.all;
  };
})

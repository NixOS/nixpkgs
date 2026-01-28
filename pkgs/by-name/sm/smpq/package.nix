{
  lib,
  cmake,
  fetchurl,
  stdenv,
  stormlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smpq";
  version = "1.7";

  src = fetchurl {
    url = "https://launchpad.net/smpq/trunk/${finalAttrs.version}/+download/smpq_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-ufmfE7Ma2qeS4yCgKkBaMiy3ZprUhHgb8v/+/790neI=";
  };

  cmakeFlags = [
    (lib.cmakeBool "WITH_KDE" false)
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ stormlib ];

  strictDeps = true;

  meta = {
    homepage = "https://launchpad.net/smpq";
    description = "StormLib MPQ archiving utility";
    license = lib.licenses.gpl3Only;
    mainProgram = "smpq";
    maintainers = with lib.maintainers; [
      aanderse
    ];
    platforms = lib.platforms.all;
  };
})

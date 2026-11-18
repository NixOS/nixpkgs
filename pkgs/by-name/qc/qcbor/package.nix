{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,

  disableFeatures ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qcbor";
  version = "1.6.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "laurencelundblade";
    repo = "QCBOR";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tpCW0YjTipdpYwgFVVV0pSb4OH3QoJSbhbb48/WhTFw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # https://github.com/laurencelundblade/QCBOR#disabling-features
    (lib.cmakeBool "QCBOR_DISABLE_ENCODE_USAGE_GUARDS" disableFeatures)
    (lib.cmakeBool "QCBOR_DISABLE_INDEFINITE_LENGTH_STRINGS" disableFeatures)
    (lib.cmakeBool "QCBOR_DISABLE_INDEFINITE_LENGTH_ARRAYS" disableFeatures)
    (lib.cmakeBool "QCBOR_DISABLE_PREFERRED_FLOAT" disableFeatures)
    (lib.cmakeFeature "BUILD_QCBOR_TEST" (if finalAttrs.doCheck then "APP" else "OFF"))
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CBOR encoder/decoder";
    homepage = "https://github.com/laurencelundblade/QCBOR";
    changelog = "https://github.com/laurencelundblade/QCBOR/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})

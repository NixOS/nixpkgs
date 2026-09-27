{
  lib,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  stdenv,
  swift,
  swiftpm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "age-plugin-se";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "remko";
    repo = "age-plugin-se";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ga9EYfvscXf8VHSptjgnjaeZT+D/69PAr/s53JOHG20=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-rGPaSlNmW4zn2bBhu3LnJvPUWBQhAfFmHnNFm9jKR+8=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "RELEASE=1"
  ];

  dontUseSwiftpmInstall = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Age plugin for Apple's Secure Enclave";
    homepage = "https://github.com/remko/age-plugin-se/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      onnimonni
      remko
    ];
    mainProgram = "age-plugin-se";
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "actor-framework";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "actor-framework";
    repo = "actor-framework";
    tag = finalAttrs.version;
    hash = "sha256-opQaRMjEgPS78wPSFRIWb5kkxcQMuAb7aAa/93LKqpo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DCAF_ENABLE_EXAMPLES:BOOL=OFF"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  checkTarget = "test";

  meta = {
    description = "Open source implementation of the actor model in C++";
    homepage = "https://www.actor-framework.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    changelog = "https://github.com/actor-framework/actor-framework/raw/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      bobakker
      tobim
    ];
  };
})

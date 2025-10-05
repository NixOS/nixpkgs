{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,

  # for passthru.tests
  libfido2,
  mysql80,
  openssh,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcbor";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = "libcbor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-13iwjc1vrTgBhWRg4vpLmlrEoxA9DSuXIOz4R9cXXEc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cmocka # cmake expects cmocka module
  ];

  # BUILD file already exists in the source
  # TODO: make unconditional on staging.
  cmakeBuildDir = if stdenv.isDarwin then "build.dir" else null;

  cmakeFlags =
    lib.optional finalAttrs.finalPackage.doCheck "-DWITH_TESTS=ON"
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "-DBUILD_SHARED_LIBS=ON";

  # Tests are restricted while pkgsStatic.cmocka is broken. Tracked at:
  # https://github.com/NixOS/nixpkgs/issues/213623
  doCheck = !stdenv.hostPlatform.isStatic && stdenv.hostPlatform == stdenv.buildPlatform;

  nativeCheckInputs = [ cmocka ];

  passthru.tests = {
    inherit libfido2 mysql80;
    openssh = (openssh.override { withFIDO = true; });
    systemd = (
      systemd.override {
        withFido2 = true;
        withCryptsetup = true;
      }
    );
  };

  meta = with lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = "https://github.com/PJK/libcbor";
    license = licenses.mit;
    maintainers = [ ];
  };
})

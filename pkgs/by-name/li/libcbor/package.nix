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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = "libcbor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zjajNtj4jKbt3pLjfLrgtYljyMDYJtnzAC5JPdt+Wys=";
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

  # BUILD file already exists in the source; this causes issues on
  # case‐insensitive Darwin systems.
  cmakeBuildDir = "build.dir";

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

  meta = {
    description = "CBOR protocol implementation for C and others";
    homepage = "https://github.com/PJK/libcbor";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})

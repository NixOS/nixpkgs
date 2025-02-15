{
  lib,
  fetchFromGitHub,
  stdenv,
  meson,
  ninja,
  pkg-config,
  testers,
}:
let
  static = stdenv.hostPlatform.isStatic;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libhydrogen";
  version = "0-unstable-2024-11-04";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "libhydrogen";
    rev = "576a38bfd14357326a9727f977b46014363eeec8";
    hash = "sha256-C8e3qsG9u9QQQ8hm8rLxL0CDA20SdcO9ChqhBFVQ7oE=";
  };

  doCheck = true;
  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  # by default upstream builds a static library, but we want both (unless isStatic)
  mesonFlags = lib.optional (!static) [ "--default-library=both" ];

  outputs = [
    "out"
    "dev"
  ];
  postInstall = ''
    mkdir -p $dev/lib/
    mv $out/lib/libhydrogen.a $dev/lib/
    mv $out/lib/pkgconfig $dev/lib/
  '';

  meta = {
    description = "Small, easy-to-use, hard-to-misuse cryptographic library";
    homepage = "https://libhydrogen.org";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ramblurr ];
    pkgConfigModules = [ "libhydrogen" ];
    platforms = lib.platforms.all;
  };
})

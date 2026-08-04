{
  fetchFromGitHub,
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sc64deployer";
  version = "2.20.2";

  src = fetchFromGitHub {
    owner = "Polprzewodnikowy";
    repo = "SummerCart64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nYnZNCE6bie+8eei3tqqkwHfbr9Pj/wMKW9KSEeSZ7k=";
  };

  cargoHash = "sha256-bE0CuAoZLx6amun+dnrgNavt0AzOS+JLz9sO+2Zf5s0=";
  sourceRoot = "source/sw/deployer";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  meta = {
    description = "SummerCart64 loader and control software";
    homepage = "https://summercart64.dev";
    license = lib.licenses.gpl3;
    mainProgram = "sc64deployer";
    maintainers = with lib.maintainers; [ nadiaholmquist ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})

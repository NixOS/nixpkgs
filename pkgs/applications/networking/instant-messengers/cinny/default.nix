{ lib
, buildNpmPackage
, fetchFromGitHub
, writeText
, jq
, python3
, pkg-config
, pixman
, cairo
, pango
, stdenv
, darwin
, conf ? { }
}:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in
buildNpmPackage rec {
  pname = "cinny";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-GC+TvTPfirov4GxkTp0N3tkDQEAEdmPB71NzOBZQiqs=";
  };

  npmDepsHash = "sha256-dP+m/ocGn8szZuakrz8slSReNeepOF4Jf7L0/gnXWGU=";

  # Fix error: no member named 'aligned_alloc' in the global namespace
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0"
  ) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

  nativeBuildInputs = [
    jq
    python3
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreText
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with lib.maintainers; [ abbe ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  writeText,
  jq,
  python3,
  pkg-config,
  pixman,
  cairo,
  pango,
  stdenv,
  darwin,
  olm,
  conf ? { },
}:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in
buildNpmPackage rec {
  pname = "cinny";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-wAa7y2mXPkXAfirRSFqwZYIJK0CKDzZG8ULzXzr4zZ4=";
  };

  npmDepsHash = "sha256-dVdylvclUIHvF5syVumdxkXR4bG1FA4LOYg3GmnNzXE=";

  # Fix error: no member named 'aligned_alloc' in the global namespace
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0"
  ) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

  nativeBuildInputs = [
    jq
    python3
    pkg-config
  ];

  buildInputs =
    [
      pixman
      cairo
      pango
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreText
    ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with maintainers; [
      abbe
      ashkitten
    ];
    license = licenses.agpl3Only;
    platforms = platforms.all;
    inherit (olm.meta) knownVulnerabilities;
  };
}

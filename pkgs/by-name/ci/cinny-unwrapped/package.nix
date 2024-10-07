{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  pkg-config,
  pixman,
  cairo,
  pango,
  stdenv,
  darwin,
  olm,
}:

buildNpmPackage rec {
  pname = "cinny-unwrapped";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-+sJQosQMji2iLGgOMRykSJm0zIhghsOsROJZvTQk2zQ=";
  };

  npmDepsHash = "sha256-VSTpe1CA6lv5MoqXyk1iZSwzRc6Axy5cM8PmqPOyheA=";

  # Fix error: no member named 'aligned_alloc' in the global namespace
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0"
  ) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.CoreText ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with lib.maintainers; [ abbe ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    inherit (olm.meta) knownVulnerabilities;
  };
}

{
  lib,
  stdenv,
  overrideSDK,
  fetchFromGitHub,
  buildNpmPackage,
  jellyfin,
  nix-update-script,
  pkg-config,
  xcbuild,
  pango,
  giflib,
  darwin,
}:
let
  # node-canvas builds code that requires aligned_alloc,
  # which on Darwin requires at least the 10.15 SDK
  stdenv' =
    if stdenv.hostPlatform.isDarwin then
      overrideSDK stdenv {
        darwinMinVersion = "10.15";
        darwinSdkVersion = "11.0";
      }
    else
      stdenv;
  buildNpmPackage' = buildNpmPackage.override { stdenv = stdenv'; };
in
buildNpmPackage' rec {
  pname = "jellyfin-web";
  version = "10.10.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    hash = "sha256-BuAvdDIvW2mQ+MzVBPGCFV73P6GxR/I3U24kCu+lXbc=";
  };

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${src.rev}" \
  '';

  npmDepsHash = "sha256-EAZm4UTc9+gW7uPiNEp2vLSKA2vOmLKKZ4/DrnGrvYQ=";

  preBuild = ''
    # using sass-embedded fails at executing node_modules/sass-embedded-linux-x64/dart-sass/src/dart
    rm -r node_modules/sass-embedded*
  '';

  npmBuildScript = [ "build:production" ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  buildInputs =
    [ pango ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      giflib
      darwin.apple_sdk.frameworks.CoreText
    ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/jellyfin-web

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      nyanloutre
      minijackson
      purcell
      jojosch
    ];
  };
}

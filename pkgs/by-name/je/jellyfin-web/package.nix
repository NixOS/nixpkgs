{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_24,
  pkg-config,
  xcbuild,
  pango,
  giflib,
  jellyfin,
}:
buildNpmPackage (finalAttrs: {
  pname = "jellyfin-web";
  version = "12.4";

  src =
    # updated together with jellyfin by its update script
    assert finalAttrs.version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ctITxOsWIEK7oLWXmhl4zCeG9Zxaqw1SA2C7zJNcyY0=";
    };

  nodejs = nodejs_24;

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${finalAttrs.src.rev}"
  '';

  npmDepsHash = "sha256-OyEdJekxJgH9VBfffmqEFmPPRfGdWpmulV1rjjDk2ks=";

  preBuild = ''
    # using sass-embedded fails at executing node_modules/sass-embedded-linux-x64/dart-sass/src/dart
    rm -r node_modules/sass-embedded*
  '';

  npmBuildScript = [ "build:production" ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  buildInputs = [
    pango
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    giflib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/jellyfin-web

    runHook postInstall
  '';

  meta = {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nyanloutre
      minijackson
      purcell
      jojosch
    ];
  };
})

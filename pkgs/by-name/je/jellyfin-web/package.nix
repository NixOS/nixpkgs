{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  nix-update-script,
  pkg-config,
  xcbuild,
  pango,
  giflib,
  jellyfin,
}:
buildNpmPackage (finalAttrs: {
  pname = "jellyfin-web";
  version = "10.11.10";

  src =
    assert finalAttrs.version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      tag = "v${finalAttrs.version}";
      hash = "sha256-fSpzF6Arx0JfL9fuQHjzf3m82XZR2BZkV0lA37L4DN4=";
    };

  nodejs = nodejs_22;

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${finalAttrs.src.rev}"
  '';

  npmDepsHash = "sha256-DCFgivbZrDufRaB+4PeFxO6ISbEM9lXhXmlzc/5GbVU=";

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

  passthru.updateScript = nix-update-script { };

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

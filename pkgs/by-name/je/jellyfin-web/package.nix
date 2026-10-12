{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "10.11.11";

  src =
    assert finalAttrs.version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      tag = "v${finalAttrs.version}";
      hash = "sha256-3Gyg0eSbOXO0wgdgzuOtD8nDmSM37z7Bc0fKcbo9ffA=";
    };

  nodejs = nodejs_22;

  patches = [
    # Escape track titles and external URLs on the item details page.
    # https://github.com/jellyfin/jellyfin-web/pull/8533
    (fetchpatch {
      url = "https://github.com/jellyfin/jellyfin-web/commit/4cffcb7d34d3707caaad68d5a0acad0c39287971.patch";
      # src/apps/legacy/ -> src/
      stripLen = 4;
      extraPrefix = "src/";
      hash = "sha256-tLZVsnKNFznKLM7K0R2oJzZeBun3g47Fbjqp0NNtx9E=";
    })
  ];

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${finalAttrs.src.rev}"
  '';

  npmDepsHash = "sha256-4kZo50xY/SvjpHToeIt0E91yeM7ab6Q6XtBMU5zSrF4=";

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

{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_20,
  nix-update-script,
  pkg-config,
  xcbuild,
  pango,
  giflib,
  jellyfin,
}:
<<<<<<< HEAD
buildNpmPackage (finalAttrs: {
  pname = "jellyfin-web";
  version = "10.11.5";

  src =
    assert finalAttrs.version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      tag = "v${finalAttrs.version}";
      hash = "sha256-9gDGREPORJILjVqw+Kk56+5qS/TQUd8OFmsEXL7KPAE=";
=======
buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.11.3";

  src =
    assert version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      rev = "v${version}";
      hash = "sha256-rsAxV3ABO1HYnVsvsIMMoWizPuFL0GyfKNUGYkqFxBc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

  nodejs = nodejs_20; # does not build with 22

  postPatch = ''
    substituteInPlace webpack.common.js \
<<<<<<< HEAD
      --replace-fail "git describe --always --dirty" "echo ${finalAttrs.src.rev}" \
  '';

  npmDepsHash = "sha256-AYGWZ5QvmQl8+ayjzkWuBra+QUvde36ReIJ7Fxk89VM=";
=======
      --replace-fail "git describe --always --dirty" "echo ${src.rev}" \
  '';

  npmDepsHash = "sha256-OLFjeCgq2c4d22L6yt7ihPuZiwsR1txZpjniuf/0L0I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      nyanloutre
      minijackson
      purcell
      jojosch
    ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

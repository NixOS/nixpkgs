{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
  pkg-config,
  xcbuild,
  pango,
  giflib,
  apple-sdk_11,
  darwinMinVersionHook,
  jellyfin,
}:
buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.10.1";

  src =
    assert version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      rev = "v${version}";
      hash = "sha256-+f+chR00eDCVZvAGNDB61c0htsVvqFK62oZorW3Qdsg=";
    };

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${src.rev}" \
  '';

  npmDepsHash = "sha256-kL57KmBHmBwJEhsUciPaj826qdoSQxZXxtFNGkddGZk=";

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
      apple-sdk_11
      # node-canvas builds code that requires aligned_alloc,
      # which on Darwin requires at least the 10.15 SDK
      (darwinMinVersionHook "10.15")
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

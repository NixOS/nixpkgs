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
buildNpmPackage rec {
  pname = "jellyfin-web";
  version = "10.11.5";

  src =
    assert version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      tag = "v${version}";
      hash = "sha256-9gDGREPORJILjVqw+Kk56+5qS/TQUd8OFmsEXL7KPAE=";
    };

  nodejs = nodejs_20; # does not build with 22

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${src.rev}" \
  '';

  npmDepsHash = "sha256-AYGWZ5QvmQl8+ayjzkWuBra+QUvde36ReIJ7Fxk89VM=";

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
}

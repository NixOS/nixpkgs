{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nodejs_24,
  npmHooks,
  pkg-config,
  stdenv,
  ffmpeg-headless,
  taglib,
  zlib,
  nixosTests,
  nix-update-script,
  ffmpegSupport ? true,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "navidrome";
  version = "0.60.3";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DwVmNJKjwEhTKIVPYFqaUR9SD4HpACkK4XJoFfQVRus=";
  };

  vendorHash = "sha256-StI4CfWN/OnbYFktRriTJWMHTuJkCinpYk9qgsxMGG8=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-EA2WM7xaqP7rS0pjx+yXwpjdauaduvDefmFH73eByxI=";
  };

  nativeBuildInputs = [
    buildPackages.makeWrapper
    nodejs_24
    npmHooks.npmConfigHook
    pkg-config
  ];

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
    preBuild = null;
  };

  buildInputs = [
    taglib
    zlib
  ];

  excludedPackages = [
    "plugins"
  ];

  ldflags = [
    "-X github.com/navidrome/navidrome/consts.gitSha=${finalAttrs.src.rev}"
    "-X github.com/navidrome/navidrome/consts.gitTag=v${finalAttrs.version}"
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    CGO_CFLAGS = toString [ "-Wno-return-local-addr" ];
    # Workaround for https://github.com/golang/go/issues/77387
    # Remove when go1.25.8 has been merged
    CGO_CFLAGS_ALLOW = "--define-prefix";
  };

  postPatch = ''
    patchShebangs ui/bin/update-workbox.sh
  '';

  preBuild = ''
    make buildjs
  '';

  tags = [
    "netgo"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
    tests.navidrome = nixosTests.navidrome;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Music Server and Streamer compatible with Subsonic/Airsonic";
    mainProgram = "navidrome";
    homepage = "https://www.navidrome.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      aciceri
      tebriel
    ];
    # Broken on Darwin: sandbox-exec: pattern serialization length exceeds maximum (NixOS/nix#4119)
    broken = stdenv.hostPlatform.isDarwin;
  };
})

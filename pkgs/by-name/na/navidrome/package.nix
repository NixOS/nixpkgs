{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,
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
  plugins ? [ ],
}:

buildGoModule (finalAttrs: {
  pname = "navidrome";
  version = "0.61.2";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "navidrome";
    rev = "v${finalAttrs.version}";
    hash = "sha256-epSgGiDdfNRUaQtWoOd4ADKtF7Ptt3p9UOqsWBzZg7I=";
  };

  vendorHash = "sha256-RmmZudmWBxiw+c9g8KFEX+ALFD0xP/SBsYc6b6RWWO8=";

  npmRoot = "ui";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-7hy2vLCEicKzjORpJZ0mrRS8PT3GsJ8DWdvj/7SrB70=";
  };

  nativeBuildInputs = [
    buildPackages.makeWrapper
    nodejs_24
    npmHooks.npmConfigHook
    pkg-config
  ];

  runtimeInputs = plugins;

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
  };

  postPatch = ''
    patchShebangs ui/bin/update-workbox.sh
  '';

  preBuild = ''
    make buildjs
  '';

  postInstall = ''
    mkdir -p $out/share/plugins/
    ${lib.concatMapStringsSep "\n" (plugin: ''
      ln -s ${plugin}/share/${plugin.pname}.ndp $out/share/plugins/
    '') plugins}
  '';

  tags = [
    "netgo"
    "sqlite_fts5"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postFixup = lib.optionalString ffmpegSupport ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
    inherit plugins;
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

{
  lib,
  stdenv,
  ncurses,
  fetchFromGitHub,
  pkg-config,
  zig_0_16,
  nix-update-script,
  zstd,
  installShellFiles,
  versionCheckHook,
  pie ? stdenv.hostPlatform.isDarwin,
}:

let
  zig = zig_0_16;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "BratishkaErik";
    repo = "ncdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wKDo8f2PVXqFopnUgZ1mTJmsdzs6iUkzXFl3VpMkGIc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    zig
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    ncurses
    zstd
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetchAll = true;
    hash = "sha256-plS7YUHWysZCQ1hHVWlgKvZkDtnjYSFfi3fdMYJVI9I=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  zigBuildFlags = [
    "-fsys=ncurses"
    "-fsys=zstd"
  ]
  ++ lib.optional pie "-Dpie=true";

  postInstall = ''
    installManPage ncdu.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/BratishkaErik/ncdu";
    description = "Disk usage analyzer with an ncurses interface";
    changelog = "https://github.com/BratishkaErik/ncdu/releases/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pSub
      rodrgz
      defelo
      ryan4yin
    ];
    inherit (zig.meta) platforms;
    mainProgram = "ncdu";
  };
})

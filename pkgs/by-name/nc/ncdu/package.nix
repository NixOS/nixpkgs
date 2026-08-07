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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "BratishkaErik";
    repo = "ncdu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YfvuXW0IaRaUNReLe/hMgYA2geDLvt1bprJAbOCFCQk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    zig.hook
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    ncurses
    zstd
  ];

  deps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetchAll = true;
    hash = "sha256-vk4wMIpKEQObFXuNd5szQQU6z0NyVJKInOMDiEn4A5k=";
  };

  postPatch = ''
    mkdir -p zig-system-dir

    for file in ${finalAttrs.deps}/*; do
       dir="zig-system-dir/$(basename "$file" .tar.gz)"
       mkdir -p "$dir"

       tar -xzf "$file" -C "$dir" --strip-components=1
    done
  '';

  zigBuildFlags = [
    "--system"
    "zig-system-dir"
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
    changelog = "https://github.com/BratishkaErik/ncdu/releases";
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

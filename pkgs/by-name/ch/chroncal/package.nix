{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "chroncal";
  version = "0.15.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DouglasdeMoura";
    repo = "chroncal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n0MMGJ+l3xCECJIxBWmGdrlK/3oCJ7LTcSoCJEGRMXs=";
  };

  vendorHash = "sha256-7QW8BQ+5Vj6eGECLxbaiZ2CEgHYIbi55g+Rzmf/txcw=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook # multiple tests need a writable $HOME for the database
  ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = stdenv.hostPlatform.isLinux; # some tests need local networking and some doesn't use correctly writableTmpDirAsHomeHook

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-first calendar, todo, and journal manager with iCalendar support and CalDAV sync";
    homepage = "https://github.com/DouglasdeMoura/chroncal";
    changelog = "https://github.com/DouglasdeMoura/chroncal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "chroncal";
  };
})

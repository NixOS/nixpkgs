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
  version = "0.7.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DouglasdeMoura";
    repo = "chroncal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N3VHM5b06UNKBMGEi3txlm/XY+sq3ic+nCEAzugz+zs=";
  };

  vendorHash = "sha256-kkorYX/WY/IHCAZExfkUVBxb8wl9kae8CWd+WVD9Q8k=";

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

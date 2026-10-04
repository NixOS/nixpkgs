{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libx11,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "lazysql";
  version = "0.5.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A9arRNJXJGbb1xuSknTVhNNe+KGxFdtv4Qhpe9stRF8=";
  };

  vendorHash = "sha256-g2gXH0PzleT77ycLosflk7gyHL59mFtDD/6ImWtGg7o=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    changelog = "https://github.com/jorgerojas26/lazysql/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazysql";
  };
})

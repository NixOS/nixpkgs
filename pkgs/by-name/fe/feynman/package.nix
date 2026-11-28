{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  autoPatchelfHook,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  python3,
  ripgrep,
  fd,
  libxcb,
}:

buildNpmPackage (finalAttrs: {
  pname = "feynman";
  version = "0.5.74";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Companion-Inc";
    repo = "feynman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1tZo+FCyt0pyDYDIJAFegNjNvWvaDvU0+du5GMH1jFk=";
  };

  npmDepsHash = "sha256-BOPUNe1Yd4PjvpivFk8U58tYUMNaC2VqN+gwKWB8gFA=";
  npmDepsFetcherVersion = 2;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    libxcb
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libc++.so.1"
    "libc++abi.so.1"
    "libunwind.so.1"
  ];

  postFixup = ''
    wrapProgram $out/bin/feynman \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          ripgrep
          fd
        ]
      } \
      --set-default PI_SKIP_VERSION_CHECK 1 \
      --set-default FEYNMAN_TELEMETRY off
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source AI research agent";
    homepage = "https://feynman.is/";
    downloadPage = "https://www.npmjs.com/package/@companion-ai/feynman";
    changelog = "https://github.com/Companion-Inc/feynman/blob/v${finalAttrs.version}/RELEASES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ZappD0S ];
    mainProgram = "feynman";
  };
})

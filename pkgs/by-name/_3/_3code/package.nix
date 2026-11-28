{
  lib,
  buildNimPackage,
  dbus,
  fetchFromGitHub,
  makeWrapper,
  openssl,
  testers,
  versionCheckHook,
}:

buildNimPackage (finalAttrs: {
  pname = "3code";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "capocasa";
    repo = "3code";
    tag = finalAttrs.version;
    hash = "sha256-hTC8Yc4+d3zUs5p34qIu1P3HMvIHdzyIvjhTc1cvvo4=";
  };

  # Match the dependency revisions in upstream's nimble.lock.
  lockFile = ./lock.json;

  buildInputs = [ openssl ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # buildNimPackage only reads `bin`; upstream uses `namedBin` to install `3code`.
    substituteInPlace threecode.nimble \
      --replace-fail 'namedBin["threecode"] = "3code"' 'bin = @["threecode"]'

    # Sandboxed commands need read/execute access to Nix-store binaries and libraries.
    substituteInPlace src/threecode/box.nim \
      --replace-fail 'var readonly = a.readOnly' \
        'var readonly = a.readOnly & @["${builtins.storeDir}"]'
  '';

  nimFlags = [
    "-d:version=${finalAttrs.version}"
  ];

  doCheck = false; # Tests are not structured for buildNimPackage's test discovery.

  postInstall = ''
    mv $out/bin/threecode $out/bin/3code
    wrapProgram $out/bin/3code \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ dbus ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.tests.sandbox = testers.runNixOSTest (
    import ./sandbox-test.nix { package = finalAttrs.finalPackage; }
  );

  meta = {
    description = "Terminal coding agent focused on token efficiency";
    homepage = "https://3code.capocasa.dev";
    changelog = "https://github.com/capocasa/3code/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "3code";
    maintainers = [ lib.maintainers.rvveber ];
    platforms = lib.platforms.linux;
  };
})

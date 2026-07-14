{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  util-linux,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "alps";
  version = "1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "migadu";
    repo = "alps";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uzr0N50qKpIoOr7YFfuhnJ/CTaMvcP7TZujM5YpklMs=";
  };

  postPatch = ''
    substituteInPlace dist/alps.service \
      --replace-fail /usr/local/bin "$out/bin" \
      --replace-fail /bin/kill "${lib.getExe' util-linux "kill"}"

    rm -r frontend/dist
    cp -r ${finalAttrs.passthru.frontend} frontend/dist
  '';

  vendorHash = "sha256-Nm9TC0j/PSraO1AtxUJmFQWdhdLzeLP0CXY0FZZ6pV8=";

  subPackages = [ "cmd/alps" ];

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm644 -t "$out/lib/systemd/system/" dist/alps.service
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    frontend = buildNpmPackage (finalAttrs': {
      pname = "${finalAttrs.pname}-frontend";
      inherit (finalAttrs) version src;
      sourceRoot = "${finalAttrs'.src.name}/frontend";

      npmDepsHash = "sha256-gR9leLQSPo/qBNf6Yy1b2klawwuhKIvofCSPYkHOJKk=";

      postPatch = ''
        rm -r dist
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out"
        cp -r dist/. "$out"

        runHook postInstall
      '';
    });
    tests = { inherit (nixosTests) alps; };
  };

  meta = {
    description = "Simple and extensible webmail";
    homepage = "https://github.com/migadu/alps";
    downloadPage = "https://github.com/migadu/alps/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booklearner
      madonius
      hmenke
      prince213
    ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "alps";
  };
})

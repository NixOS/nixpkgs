{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  postgresql,
  postgresqlTestHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "sstorytime";
  version = "1.0-beta-unstable-2026-08-20";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "markburgess";
    repo = "SSTorytime";
    rev = "a9b34d5197cb0a9fb586bc4722eb8153dffaf044";
    hash = "sha256-NYMIxUlx5jf2weTdMxziMhZ7dMxPc5L330wRFzhDmFw=";
  };

  vendorHash = "sha256-lei5IG02QYSigHmLArlE7huDFVGoVMkw8DTEQeJWFX0=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  excludedPackages = [
    "API_EXAMPLE"
    "demo_pocs"
  ];

  outputs = [
    "out"
    "examples"
  ];

  # Prefer installCheck so a cd into tests/ cannot clobber install.
  # postgresqlTestHook only registers preCheck/postCheck hooks, so start/stop explicitly.
  doCheck = false;
  doInstallCheck = true;

  nativeInstallCheckInputs = [
    postgresql
    postgresqlTestHook
    writableTmpDirAsHomeHook
  ];

  # Peer on the hook's Unix socket: role = build user. SUPERUSER for schema setup.
  env = {
    PGUSER = "nixbld";
    PGDATABASE = "sstoryline";
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
  };

  postInstall = ''
    # cmd/server installs as "server"; upstream Makefile calls it http_server.
    mv $out/bin/server $out/bin/http_server

    mkdir -p $examples/share
    cp -a examples $examples/share/
    install -Dm644 SSTconfig/* -t $out/share/SSTconfig
  '';

  postFixup = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --set-default SST_CONFIG_PATH "$out/share/SSTconfig"
    done
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    postgresqlStart
    export POSTGRESQL_URI="postgresql://$PGUSER@/$PGDATABASE?host=$PGHOST"

    failed=0
    bin=$out/bin/N4L

    for f in tests/pass_*.in; do
      if "$bin" -adj=all "$f" >/dev/null; then
        echo "ok $f"
      else
        echo "FAIL $f"
        failed=1
      fi
    done

    for f in tests/fail_*.in; do
      if "$bin" "$f" >/dev/null 2>&1; then
        echo "FAIL $f (expected non-zero exit)"
        failed=1
      else
        echo "ok $f"
      fi
    done

    if "$bin" -wipe -u examples/doors.n4l >/dev/null; then
      echo "ok N4L -wipe -u doors.n4l"
    else
      echo "FAIL N4L -wipe -u doors.n4l"
      failed=1
    fi

    postgresqlStop

    if [ "$failed" -ne 0 ]; then
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit (nixosTests) sstorytime; };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Unified graph process for mapping knowledge";
    homepage = "https://github.com/markburgess/SSTorytime";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.ngi ];
    maintainers = [ lib.maintainers.lucasew ];
    mainProgram = "N4L";
  };
})

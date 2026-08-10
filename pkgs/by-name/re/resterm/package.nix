{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "resterm";
  version = "0.49.4";

  src = fetchFromGitHub {
    owner = "unkn0wn-root";
    repo = "resterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4hLhmQ2ks1g9eF+wKKLc8/6g07IHisgwYMBhGr4DjbE=";
  };

  vendorHash = "sha256-K6edyYLkVQwEZBAfRwgckUJI8dmo/ZxFRjEkExtyLxY=";

  # modernc.org/libc (via modernc.org/sqlite) tries to read /etc/protocols
  modPostBuild = ''
    substituteInPlace vendor/modernc.org/libc/honnef.co/go/netdb/netdb.go \
      --replace-fail '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';

  subPackages = [ "cmd/resterm" ];

  # Skip tests that require network access or socket binding
  checkFlags = [
    "-skip"
    "^(${
      lib.concatStringsSep "|" [
        "TestServeMocksStartsAndStopsWithContext"
        "TestServeMocksRequiresTLSPair"
        "TestServeMocksValidatesJournalLimitsAsUsageErrors"
        "TestMockControlCommandsResetClearAndVerify"
        "TestCLIUpdaterCheckDev"
      ]
    })$"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.date=1970-01-01_00:00:00_UTC"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based REST client";
    homepage = "https://github.com/unkn0wn-root/resterm";
    mainProgram = "resterm";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})

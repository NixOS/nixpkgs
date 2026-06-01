{
  lib,
  stdenv,
  nixosTests,

  buildGoModule,
  fetchFromGitHub,
  installShellFiles,

  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "etcd";
  version = "3.7.0-rc.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KnPU+z6Dl7g54tH/EKPC8zTpStQ0JcsNLALn/2Wh7lI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-3lJypE6AzxVljXbJMYz8+yk/uxlk9TkgIV/fezgsEPI=";

  overrideModAttrs = _: {
    buildPhase = ''
      go work vendor -e -v
    '';
  };

  env = {
    CGO_ENABLED = 0;
  };

  ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];

  checkFlags = [
    "--tags"
    "integration"
  ]
  ++ map (t: "-run=!S/${t}") [
    "TestGetDefaultInterface"
    "TestGetDefaultHost"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm544 $GOPATH/bin/{etcdutl,etcdctl} -t $out/bin
    install -Dm544 $GOPATH/bin/server $out/bin/etcd
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cmd in etcdutl etcdctl; do
      for shell in bash fish zsh; do
        installShellCompletion --cmd $cmd \
          --$shell <($out/bin/etcdutl completion $shell)
      done
    done
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.etcd."3_7";
  };

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    homepage = "https://github.com/etcd-io/etcd";
    changelog = "https://github.com/etcd-io/etcd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dtomvan
      superherointj
    ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    mainProgram = "etcd";
  };
})

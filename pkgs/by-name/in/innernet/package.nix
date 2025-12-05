{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
  installShellFiles,
  libiconv,
  innernet,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    tag = "v${version}";
    hash = "sha256-wGxTdoWMHVUldW+bjli+5zqo3PRU/8tn7fxAeVrynjs=";
  };

  cargoHash = "sha256-vDPs+EEl/ZbKxOrNHc86N7+5ij+4YmsZRo5/Sxja6ms=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  postInstall = ''
    installManPage doc/innernet-server.8.gz
    installManPage doc/innernet.8.gz
    installShellCompletion doc/innernet.completions.{bash,fish,zsh}
    installShellCompletion doc/innernet-server.completions.{bash,fish,zsh}
  ''
  + (lib.optionalString stdenv.hostPlatform.isLinux ''
    find . -regex '.*\.\(target\|service\)' | xargs install -Dt $out/lib/systemd/system
    find $out/lib/systemd/system -type f | xargs sed -i "s|/usr/bin/innernet|$out/bin/innernet|"
  '');

  passthru.tests = {
    serverVersion = testers.testVersion {
      package = innernet;
      command = "innernet-server --version";
    };
    version = testers.testVersion {
      package = innernet;
      command = "innernet --version";
    };
  };

  meta = {
    description = "Private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    changelog = "https://github.com/tonarino/innernet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tomberek
      _0x4A6F
    ];
  };
}

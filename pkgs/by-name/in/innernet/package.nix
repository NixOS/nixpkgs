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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "innernet";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7pvQFxXf1MCmnNNQIGGkI2jhL9jC/ZLZqwiJPSFC1b8=";
  };

  cargoHash = "sha256-CaE2VH5CuOuEATcYrt7p7yQFQ5s0tZZomvy9VltRpRI=";

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
    changelog = "https://github.com/tonarino/innernet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tomberek
      _0x4A6F
    ];
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  bash,
  coreutils,
  gnutar,
  gzip,
  makeWrapper,
}:

buildGoModule {
  pname = "spread";
  version = "0-unstable-2025-02-06";

  src = fetchFromGitHub {
    owner = "snapcore";
    repo = "spread";
    rev = "d6447c43754c8ca0741901e9db73d5fdb4d21c93";
    hash = "sha256-6d7FuEzO5Ond3xjKpf5iRIp9LEV/4O5g3j/tZQEDCZg=";
  };

  vendorHash = "sha256-yKDz8Hz8T6D7MZAV8ePa3mVwo4jycX3uVgzxjRp2O5o=";

  subPackages = [ "cmd/spread" ];

  nativeBuildInputs = [ makeWrapper ];

  patches = [
    # The upstream project statically assigns a PATH when running scripts in the
    # local machine context. This patch keeps that static PATH assignment, but also
    # appends the PATH from the environment context in which spread was run, so
    # that nix-installed binaries are also available.
    ./local-script-path.patch
  ];

  postPatch = ''
    # Replace direct calls to /bin/bash
    substituteInPlace spread/lxd.go --replace-fail '"/bin/bash", ' '"/usr/bin/env", "bash", '
    substituteInPlace spread/client.go --replace-fail '"/bin/bash", ' '"/usr/bin/env", "bash", '
    substituteInPlace spread/project.go --replace-fail '"/bin/bash", ' '"/usr/bin/env", "bash", '
  '';

  postInstall = ''
    wrapProgram $out/bin/spread --prefix PATH : ${
      lib.makeBinPath [
        bash
        coreutils
        gnutar
        gzip
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "spread";
    license = lib.licenses.gpl3Only;
    description = "Convenient full-system test (task) distribution";
    homepage = "https://github.com/snapcore/spread";
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.unix;
  };
}

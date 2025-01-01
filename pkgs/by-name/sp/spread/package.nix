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
  version = "0-unstable-2023-03-01";

  src = fetchFromGitHub {
    owner = "snapcore";
    repo = "spread";
    rev = "ded9133cdbceaf01f8a1c9decf6ff9ea56e194d6";
    hash = "sha256-uHBzVABfRCyBAGP9f+2GS49Qc8R9d1HaRr6bYPeVSU4=";
  };

  vendorHash = "sha256-SULAfCLtNSnuUXvA33I48hnhU0Ixq79HhADPIKYkWNU=";

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

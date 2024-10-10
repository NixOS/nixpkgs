{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  bash,
}:

buildGoModule {
  pname = "mkuimage";
  version = "0-unstable-2024-02-28";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "mkuimage";
    rev = "899a47eaaa318bd2327dc94d964ccda40a784037";
    hash = "sha256-sb/LtwAN7RN8jWG/x6pomz2Q+vKekA/teC7U5NVb2qY=";
  };

  vendorHash = "sha256-KX9uv5m4N4+7gOgjhotRac9sz8tWSJ1krq98RWdsbzg=";

  subPackages = [
    "cmd/gentpldeps"
    "cmd/mkuimage"
  ];

  CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  # The tests want to copy /bin/bash and /bin/ls, but we don't have those.
  # As these are interesting e2e tests to check if things work, we substitute
  # them with the actual paths instead of just skipping the tests.
  preCheck = ''
    substituteInPlace ./cmd/mkuimage/main_test.go \
      --replace-fail '-files=/bin/bash"' '-files=${bash}/bin/bash:bin/bash"' \
      --replace-fail '-files=/bin/ls"' '-files=${coreutils}/bin/ls:bin/ls"' \
      --replace-fail '-files=/bin/bash' '-files=${bash}/bin/bash'
  '';

  meta = {
    description = "Create small Go-based root file systems -- with support for CPIOs and (TBD) Docker images";
    homepage = "https://github.com/u-root/mkuimage";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "mkuimage";
  };
}

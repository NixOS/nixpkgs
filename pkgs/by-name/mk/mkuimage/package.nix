{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  bash,
  stdenv,
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

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  # Tests are failing on darwin as they try to compile u-root binaries
  # that only work on linux.
  #
  # Notice that due to some legacy/bug in buildGoModule, the build isn't
  # failing even the tests are, as we get a false-positive the output
  # filtering: https://github.com/NixOS/nixpkgs/issues/349468
  doCheck = stdenv.hostPlatform.isLinux;

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

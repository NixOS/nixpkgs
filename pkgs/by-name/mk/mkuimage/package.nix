{
  lib,
  # Build fails with Go 1.25, with the following error:
  # 'vendor/golang.org/x/tools/internal/tokeninternal/tokeninternal.go:64:9: invalid array length -delta * delta (constant -256 of type int64)'
  # Wait for upstream to update their vendored dependencies before unpinning.
  buildGo124Module,
  fetchFromGitHub,
  coreutils,
  bash,
  stdenv,
}:

buildGo124Module {
  pname = "mkuimage";
  version = "0-unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "mkuimage";
    rev = "9a40452f5d3ba67f236a83de54fa2c40f797b68b";
    hash = "sha256-asC4j2DXkQnx6BZntxA8hSaM2k6p0CxraHYq3bK9vNQ=";
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

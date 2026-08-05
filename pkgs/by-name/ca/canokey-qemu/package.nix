{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3Packages,
  unstableGitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "canokey-qemu";
  version = "0-unstable-2026-03-24";
  rev = "41044ec17ddb835b3e5acb385a2e429aa74af627";

  src = fetchFromGitHub {
    owner = "canokeys";
    repo = "canokey-qemu";
    inherit rev;
    fetchSubmodules = true;
    hash = "sha256-eunhMRp3HJ80kCCZbiMGNjA9b0uUMzOsSeNh61d1iJU=";
  };

  postPatch = ''
    substituteInPlace canokey-core/CMakeLists.txt \
      --replace-fail "git describe --always --tags --long --abbrev=8 --dirty >>" "echo '$rev' >>"
  ''
  + (lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_library(canokey-qemu SHARED" "add_library(canokey-qemu STATIC"
  '');

  preConfigure = ''
    cmakeFlagsArray+=(
      -DCMAKE_C_FLAGS=${
        lib.escapeShellArg (
          [
            "-Wno-error=unused-but-set-parameter"
            "-Wno-error=unused-but-set-variable"
          ]
          ++ lib.optionals stdenv.cc.isClang [
            "-Wno-error=documentation"
          ]
          ++ lib.optionals stdenv.cc.isGNU [
            # canokey-qemu contains a vendored copy of mbedtls, and
            # mbedtls widely uses a pattern of starting unions with an
            # unsigned int dummy member, and then initializing those unions to
            # { 0 }.  The problem with this is that it only initializes that
            # first union member, so in the common case where the non-dummy
            # members are larger than the dummy member, they will only be
            # partially initialized since GCC 15[1].  Upstream has added
            # ad-hoc memset calls to mitigate this issue, but initializers are
            # also still widely used.  To avoid the risk of using
            # uninitialized memory, force the compiler to zero all bits of
            # unions, not just the first element, until upstream has a
            # systemic fix in place[2].
            #
            # [1]: https://gcc.gnu.org/gcc-15/changes.html
            # [2]: https://github.com/Mbed-TLS/mbedtls/issues/9885
            "-fzero-init-padding-bits=unions"
          ]
        )
      }
    )
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3Packages.jsonschema
    python3Packages.jinja2
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/canokeys/canokey-qemu";
    description = "CanoKey QEMU Virtual Card";
    longDescription = "A virtual OPENPGP and FIDO2 card. Only for testing purpose. There is no warranty on security.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ symphorien ];
  };
}

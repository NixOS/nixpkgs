{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "canokey-qemu";
  version = "0-unstable-2023-06-06";
  rev = "151568c34f5e92b086b7a3a62a11c43dd39f628b";

  src = fetchFromGitHub {
    owner = "canokeys";
    repo = "canokey-qemu";
    inherit rev;
    fetchSubmodules = true;
    hash = "sha256-4V/2UOgGWgL+tFJO/k90bCDjWSVyIpxw3nYi9NU/OxA=";
  };

  patches = [
    ./canokey-qemu-memcpy.patch
  ];

  postPatch = ''
    substituteInPlace canokey-core/CMakeLists.txt \
      --replace "COMMAND git describe --always --tags --long --abbrev=8 --dirty >>" "COMMAND echo '$rev' >>"
  '';

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
        )
      }
    )
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/canokeys/canokey-qemu";
    description = "CanoKey QEMU Virt Card";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxalica ];
  };
}

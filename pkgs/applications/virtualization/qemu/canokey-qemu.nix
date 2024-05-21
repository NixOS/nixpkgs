{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "canokey-qemu";
  version = "unstable-2022-06-23";
  rev = "b70af31229f1858089c3366f71b8d771de4a1e84";

  src = fetchFromGitHub {
    owner = "canokeys";
    repo = "canokey-qemu";
    inherit rev;
    fetchSubmodules = true;
    hash = "sha256-VJb59K/skx+DhoJs5qGUu070hAjQZC2Z6hAMXuX0bMw=";
  };

  postPatch = ''
    substituteInPlace canokey-core/CMakeLists.txt \
      --replace "COMMAND git describe --always --tags --long --abbrev=8 --dirty >>" "COMMAND echo '$rev' >>"
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/canokeys/canokey-qemu";
    description = "CanoKey QEMU Virt Card";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxalica ];
  };
}

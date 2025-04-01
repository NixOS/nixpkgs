{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_11,
}:

stdenv.mkDerivation {
  pname = "minizign";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "zig-minisign";
    rev = "47edc26d0c7bcfb531fe08e3b2411d8dda516d47";
    hash = "sha256-zyxjUFxg+VufEVycYGCQPdjERE3p5Vz5iIi2UDujEjI=";
  };

  nativeBuildInputs = [
    zig_0_11.hook
  ];

  meta = with lib; {
    description = "Minisign reimplemented in Zig";
    homepage = "https://github.com/jedisct1/zig-minisign";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "minizign";
    inherit (zig_0_11.meta) platforms;
  };
}

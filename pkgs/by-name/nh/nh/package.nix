{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  nh-unwrapped,
  nix-output-monitor,
}:
let
  unwrapped = nh-unwrapped;
  runtimeDeps = [
    nix-output-monitor
  ];
in
symlinkJoin {
  pname = "nh";
  inherit (unwrapped) version meta;

  paths = [
    unwrapped
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';
}

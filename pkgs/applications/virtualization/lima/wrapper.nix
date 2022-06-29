{ lib
, runCommandLocal
, makeWrapper
, lima-unwrapped
, qemu
, extraPackages ? [ ]
}:

let
  lima = lima-unwrapped;

  binPath = lib.makeBinPath (
    [
      qemu
    ]
    ++ extraPackages
  );

in
runCommandLocal lima.name
{
  name = "${lima.pname}-wrapper-${lima.version}";

  inherit (lima) pname version passthru;

  meta = builtins.removeAttrs lima.meta [ "outputsToInstall" ];

  nativeBuildInputs = [ makeWrapper ];
}
  ''
    mkdir -p $out/bin
    ln -s ${lima-unwrapped}/share $out/share
    makeWrapper ${lima-unwrapped}/bin/limactl $out/bin/limactl \
      --prefix PATH : ${lib.escapeShellArg binPath}
  ''

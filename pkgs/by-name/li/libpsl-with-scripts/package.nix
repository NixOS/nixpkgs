{
  lib,
  stdenv,
  libpsl,
  python3,
  lzip,
}:

stdenv.mkDerivation {
  pname = "libpsl-with-scripts";
  inherit (libpsl) src version patches;
  outputs = libpsl.outputs ++ [ "bin" ];

  nativeBuildInputs = [
    lzip
  ];

  buildInputs = [
    python3
  ];

  postPatch = ''
    patchShebangs src/psl-make-dafsa
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    let
      linkOutput = oldOutput: newOutput: ''
        cd ${oldOutput}
        find . -type d -print0 | xargs -0 -I{} mkdir -p ${newOutput}/{}
        find . \( -type f -o -type l \) -print0 | xargs -0 -I{} ln -s ${oldOutput}/{} ${newOutput}/{}
        cd -
      '';
      links = lib.concatMapStrings (
        output: linkOutput libpsl.${output} (placeholder output)
      ) libpsl.outputs;
    in
    ''
      runHook preInstall

      ${links}

      install -D src/psl-make-dafsa $bin/bin/psl-make-dafsa
      install -D -m 555 src/psl-make-dafsa.1 $out/share/man/man1/psl-make-dafsa.1

      runHook postInstall
    '';

  dontFixup = true;
}

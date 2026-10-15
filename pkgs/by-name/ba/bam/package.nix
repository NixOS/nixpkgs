{
  lib,
  stdenv,
  fetchFromGitHub,
  lua5_3,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bam";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "matricks";
    repo = "bam";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bt/IBT850Dx7kd3IAUrF+fmWBXMlNOf/fp6eF8s4eY0=";
  };

  nativeBuildInputs = [
    lua5_3
    python3
  ];

  buildPhase = "${stdenv.shell} make_unix.sh";

  checkPhase = "${python3.interpreter} scripts/test.py";

  strictDeps = true;

  installPhase = ''
    mkdir -p "$out/share/bam"
    cp -r docs examples tests  "$out/share/bam"
    mkdir -p "$out/bin"
    cp bam "$out/bin"
  '';

  meta = {
    description = "Yet another build manager";
    homepage = "https://github.com/matricks/bam";
    mainProgram = "bam";
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.zlib;
    downloadPage = "https://matricks.github.io/bam/";
  };
})

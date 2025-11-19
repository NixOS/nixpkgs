{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "loki-tool";
  version = "0-unstable-2016-06-27";

  src = fetchFromGitHub {
    owner = "djrbliss";
    repo = "loki";
    rev = "784e86f981b7b1c30bd0d6b401f071e47e738eb8";
    hash = "sha256-yeLTQP8TYDkaMmynRxmATPi2/5VxkUZsYd44UQwz4PY=";
  };

  strictDeps = true;

  # Static build does not work on darwin due to linker issues
  postPatch = ''
    substituteInPlace Makefile --replace-fail \
      "CFLAGS += -g -static -Wall" "CFLAGS += -g -Wall"
  '';

  # Default build target tries to compile binary for Android
  buildPhase = ''
    runHook preBuild
    make CC=cc loki_tool
    runHook postBuild
  '';

  # Upstream has no install target
  installPhase = ''
    runHook preInstall
    install -Dm555 loki_tool -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/djrbliss/loki";
    description = "Tool for custom firmware on AT&T/Verizon Samsung and LG devices";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "loki_tool";
  };
}

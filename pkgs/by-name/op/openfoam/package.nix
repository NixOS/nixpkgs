{
  lib,
  stdenv,
  openfoam-unwrapped,
  flex,
  openmpi,
  paraview,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "openfoam";
  version = openfoam-unwrapped.version;

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  nativeBuildInputs = [
    flex
    openmpi
    makeWrapper
  ];

  installPhase = ''
    OUT_DIR="${openfoam-unwrapped}/opt/OpenFOAM-${openfoam-unwrapped.version}"

    wrapDir() {
      local dir="$1"

      for f in "$dir"/*; do
        [ -f "$f" ] || continue
        [ -x "$f" ] || continue

        local name
        name="$(basename "$f")"

        makeWrapper "$f" "$out/bin/$name" \
          --run "
            set +eu

            export PATH="${lib.makeBinPath [ paraview ]}:$PATH"

            source "$OUT_DIR/etc/bashrc"
          "
      done
    }

    set +eu
    source "$OUT_DIR/etc/bashrc"
    set -eu

    mkdir -p "$out/bin"

    wrapDir "$OUT_DIR/bin"
    wrapDir "$OUT_DIR/platforms/$WM_OPTIONS/bin"

    mkdir -p "$out/share/man/man1"

    $OUT_DIR/bin/tools/foamCreateManpage \
      -dir="$out/bin" \
      -output="$out/share/man/man1" \
      -version="v${openfoam-unwrapped.version}"

    mkdir -p "$out/share/openfoam"
    mkdir -p "$out/share/bash-completion/completions"

    cp "$OUT_DIR/etc/config.sh/bash_completion" "$out/share/openfoam/bash_completion"

    $OUT_DIR/bin/tools/foamCreateCompletionCache \
      -dir "$out/bin" \
      -o "$out/share/openfoam/completion_cache"

    cat > "$out/share/bash-completion/completions/openfoam" <<EOF
      FOAM_APPBIN="$out/bin"
      source "$out/share/openfoam/completion_cache"
      source "$out/share/openfoam/bash_completion"
    EOF

    for f in "$out/bin"/*; do
      [ -f "$f" ] || continue
      [ -x "$f" ] || continue

      name="$(basename "$f")"

      ln -s openfoam "$out/share/bash-completion/completions/$name"
    done
  '';

  meta = openfoam-unwrapped.meta;
}

{
  magma,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation {
  name = "${magma.name}-pkg-config-consumer";
  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ magma ];
  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    cat > consumer.cpp <<'CPP'
    #include <magma_v2.h>
    #include <magmasparse.h>
    int main() {
      magma_init();
      magma_int_t info = 0, pivot;
      float a = 1, b = 1;
      magma_sgesv(1, 1, &a, 1, &pivot, &b, 1, &info);
      magma_s_matrix matrix{};
      magma_smfree(&matrix, nullptr);
      magma_finalize();
      return info;
    }
    CPP

    # Only the installed .pc interface may supply headers and libraries.
    # Keep pkg-config's normal role-aware lookup, but clear stdenv input flags.
    for role in "" _FOR_BUILD _FOR_HOST _FOR_TARGET; do
      unset "NIX_CFLAGS_COMPILE$role" "NIX_LDFLAGS$role"
    done
    local actualVersion
    actualVersion=$($PKG_CONFIG --modversion magma)
    if [[ $actualVersion != '${magma.version}' ]]; then
      echo "magma.pc version: expected ${magma.version}, got '$actualVersion'" >&2
      exit 1
    fi
    local -a cflags libs
    read -r -a cflags <<< "$($PKG_CONFIG --cflags magma)"
    if printf '%s\n' "''${cflags[@]}" | grep -E '/build/|cuda_nvcc[^/]*/include'; then
      echo "magma.pc exposes build-only include paths" >&2
      exit 1
    fi
    "$CXX" "''${cflags[@]}" -std=c++17 -c consumer.cpp -o consumer.o

    # Link separately: Libs must identify MAGMA's OpenMP runtime.
    # --static here selects metadata for static MAGMA; CUDA may still be shared.
    for mode in ordinary static; do
      local -a options=()
      if [[ $mode == static ]]; then options+=(--static); fi
      read -r -a libs <<< "$($PKG_CONFIG "''${options[@]}" --libs magma)"
      "$CXX" consumer.o "''${libs[@]}" -o "consumer-$mode"
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp consumer-{ordinary,static} "$out/bin/"
    runHook postInstall
  '';
}

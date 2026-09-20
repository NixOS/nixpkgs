{
  magma,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation {
  name = "${magma.name}-sparse-consumer";
  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ magma ];
  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    # Use only the installed public metadata, including split CUDA headers.
    for role in "" _FOR_BUILD _FOR_HOST _FOR_TARGET; do
      unset "NIX_CFLAGS_COMPILE$role" "NIX_LDFLAGS$role"
    done
    local -a cflags libs
    $PKG_CONFIG --cflags magma > cflags.txt
    $PKG_CONFIG --libs magma > libs.txt
    read -r -a cflags < cflags.txt
    read -r -a libs < libs.txt
    for variant in s:REAL_SINGLE d:REAL_DOUBLE c:COMPLEX_SINGLE z:COMPLEX_DOUBLE; do
      local precision="''${variant%%:*}" scalar="''${variant#*:}"
      "$CXX" "''${cflags[@]}" -std=c++17 -O2 \
        -DPRECISION="$precision" -D"$scalar" \
        ${./sparse-consumer.cpp} "''${libs[@]}" -o "magma-sparse-$precision"
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/magma-sparse"
    cp magma-sparse-{s,d,c,z} "$out/bin/"
    cp cflags.txt libs.txt "$out/share/magma-sparse/"
    printf '%s\n' '${magma}' > "$out/share/magma-sparse/producer"
    runHook postInstall
  '';

  # Execution needs HOST's GPU and driver; the build itself is cross-safe.
  passthru = { inherit magma; };
}

{ self
, attrOverrides ? { }
}:

self.overrideAttrs (old: {
  name = if old?pname then "${old.pname}-deps-${old.version}" else "${old.name}-deps";
  pname = null;
  version = null;
  phases = [ "unpackPhase" "patchPhase" "configurePhase" "installPhase" ];
  mitmCache = null;
  dontUseGradleConfigure = true;
  outputs = [ "out" ];
  disallowedReferences = [ ];
  installPhase = ''
    mkdir -p "$out"
    declare -p mitmCachePort > "$out/script1" || true
    declare -p gradleFlags gradleFlagsArray > "$out/script2" || true
    echo "cd '$(realpath --relative-base="$NIX_BUILD_TOP" .)'" >> "$out/script2"
    echo "$preBuild" >> "$out/script2"
    cp -r "$NIX_BUILD_TOP" "$out/src"
  '';
} // attrOverrides)

# A derivation that unpacks and patches the source, and also runs the configure
# phase and exports some env variables and the current working directory
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
    declare -p gradleFlags gradleFlagsArray > "$out/script" || true
    echo "cd '$(realpath --relative-base="$NIX_BUILD_TOP" .)'" >> "$out/script"
    echo "$preBuild" >> "$out/script"
    cp -r "$NIX_BUILD_TOP" "$out/src"
  '';
} // attrOverrides)

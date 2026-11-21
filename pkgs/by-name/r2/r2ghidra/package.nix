{
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  pkg-config,
  python3,
  radare2,
  stdenv,
  zlib,
}:
let
  ghidraNative = fetchFromGitHub {
    owner = "radareorg";
    repo = "ghidra-native";
    rev = "483ae94bcbc661a77667e52f1eff75928cb6aa2e";
    hash = "sha256-3cig2WwnqUiDugyIKrX+hLGXt39J2P+YOM6/LHMDMyU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "r2ghidra";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "r2ghidra";
    tag = finalAttrs.version;
    hash = "sha256-a5iNF1fELpIRgp9tNEZ3CsgTfDtzFFiTiDekBP8/S7M=";
  };

  postUnpack = ''
    cp -r ${ghidraNative} "$sourceRoot/subprojects/ghidra-native"
    chmod -R u+w "$sourceRoot/subprojects/ghidra-native"
    cp -r "$sourceRoot/subprojects/packagefiles/ghidra-native/." "$sourceRoot/subprojects/ghidra-native"

    substituteInPlace "$sourceRoot/subprojects/ghidra-native/meson.build" \
      --replace-fail 'link_with: slgh_static,' 'link_with: [slgh_static, ghidra_decompiler_static],'

    for patch in "$sourceRoot"/subprojects/packagefiles/ghidra-native/patches/*.patch; do
      patch -d "$sourceRoot/subprojects/ghidra-native" -p1 < "$patch"
    done
  '';

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "res = run_command(['radare2','-HR2_LIBR_PLUGINS'], capture:true, check:false)" \
        "res = run_command('false', capture:true, check:false)"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    radare2
    zlib
  ];

  mesonFlags = [ "--libdir=lib" ];

  nativeInstallCheckInputs = [ radare2 ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    R2_LIBR_PLUGINS="$out/lib/radare2/plugins" \
      SLEIGHHOME="$out/lib/radare2/plugins/r2ghidra_sleigh" \
      radare2 -N -q -e bin.cache=true -c 'aaa; s entry0; pdg' ${lib.getExe radare2} 2>&1 \
      | grep -q 'entry0'

    runHook postInstallCheck
  '';

  meta = {
    description = "Native Ghidra decompiler plugin for radare2";
    homepage = "https://github.com/radareorg/r2ghidra";
    changelog = "https://github.com/radareorg/r2ghidra/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      lgpl3Only
    ];
    longDescription = ''
      Set R2_LIBR_PLUGINS to ${placeholder "out"}/lib/radare2/plugins and
      SLEIGHHOME to the r2ghidra_sleigh directory beneath it when launching
      radare2.
    '';
    maintainers = with lib.maintainers; [
      arkivm
      azahi
    ];
    platforms = lib.platforms.unix;
  };
})

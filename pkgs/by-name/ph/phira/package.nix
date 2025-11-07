{
  lib,
  stdenv,
  symlinkJoin,
  fetchzip,
  phira-unwrapped,
  makeWrapper,
  libGL,
  # A derivation or a path that contains a dir `assets`.
  overrideAssets ? fetchzip {
    url = "https://github.com/TeamFlos/phira/releases/download/v${phira-unwrapped.version}/Phira-windows-v${phira-unwrapped.version}.zip";
    hash = "sha256-kgmIIIzg+wxyspQTyW1GucW0RVPfBhIRlK5DEGXK1Qs=";
    stripRoot = false;
    meta.license = lib.licenses.unfree;
  },
}:

symlinkJoin {
  pname = "phira";
  version = phira-unwrapped.version;

  paths = [ phira-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    phira_root=$out/share/phira
    mkdir -p $phira_root
    cp -r ${overrideAssets}/assets $phira_root

    wrapper_options=(
      ${lib.optionalString stdenv.hostPlatform.isLinux "--suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}"}
      --run '
        export PHIRA_ROOT=''${PHIRA_ROOT-"''${XDG_DATA_HOME-"$HOME/.local/share"}/phira"}
        if [[ ! -d "$PHIRA_ROOT/assets" ]]; then
          mkdir -p "$PHIRA_ROOT"
          cp -r "'$phira_root/assets'" "$PHIRA_ROOT"
          chmod -R +w "$PHIRA_ROOT/assets"
        fi
      '
    )

    wrapProgram $out/bin/phira-main "''${wrapper_options[@]}"
    wrapProgram $out/bin/phira-monitor "''${wrapper_options[@]}"
  '';

  passthru.assets = overrideAssets;

  meta = phira-unwrapped.meta;

}

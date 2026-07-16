{
  lib,
  stdenv,
  symlinkJoin,
  fetchzip,
  phira-unwrapped,
  makeWrapper,
  libGL,
  libx11,
  libxi,
  libxcursor,
  # A derivation or a path that contains a dir `assets`.
  overrideAssets ? fetchzip {
    url = "https://github.com/TeamFlos/phira/releases/download/v${phira-unwrapped.version}/Phira-windows-x86_64-v${phira-unwrapped.version}.zip";
    hash = "sha256-p0+o7q42caHqVWnHtgknYaCIJemG/9fNKF7pqTnRGE4=";
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
      ${lib.optionalString stdenv.hostPlatform.isLinux "--suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libx11
          libxi
          libxcursor
        ]
      }"}
      --run '
        export PHIRA_ROOT=''${PHIRA_ROOT-"''${XDG_DATA_HOME-"$HOME/.local/share"}/phira"}
        mkdir -p "$PHIRA_ROOT"
        cp -L -r --update=none "'$phira_root/assets'" "$PHIRA_ROOT"
        chmod -R +w "$PHIRA_ROOT/assets"
      '
    )

    wrapProgram $out/bin/phira-main "''${wrapper_options[@]}"
    wrapProgram $out/bin/phira-monitor "''${wrapper_options[@]}"
  '';

  passthru.assets = overrideAssets;

  meta = phira-unwrapped.meta;

}

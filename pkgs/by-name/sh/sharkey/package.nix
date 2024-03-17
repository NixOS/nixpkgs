{ lib
, stdenv
, stdenvNoCC
, fetchFromGitLab
, makeWrapper
, copyDesktopItems
, jemalloc
, ffmpeg-headless
, jq
, python3
, pkg-config
, glib
, vips
, moreutils
, cacert
, nodePackages
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sharkey";
  version = "2024.3.1";

  src = fetchFromGitLab {
    owner = "TransFem-org";
    repo = "Sharkey";
    domain = "activitypub.software";
    rev = "${finalAttrs.version}";
    hash = "sha256-+lu0l/TA2Ge/flTUyyV/i0uzh4aycSGVCSQMkush8zA=";
    fetchSubmodules = true;
  };

  # NOTE: This requires pnpm 8.10.0 or newer
  # https://github.com/pnpm/pnpm/pull/7214
  pnpmDeps =
    assert lib.versionAtLeast nodePackages.pnpm.version "8.10.0";
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-pnpm-deps";
      inherit (finalAttrs) src version;

      nativeBuildInputs = [
        jq
        moreutils
        nodePackages.pnpm
        cacert
      ];

      pnpmPatch = builtins.toJSON {
        pnpm.supportedArchitectures = {
          os = [ "linux" ];
          cpu = [ "x64" "arm64" ];
        };
      };

      postPatch = ''
        mv package.json package.json.orig
        jq --raw-output ". * $pnpmPatch" package.json.orig > package.json
      '';

      # https://github.com/NixOS/nixpkgs/blob/763e59ffedb5c25774387bf99bc725df5df82d10/pkgs/applications/misc/pot/default.nix#L56
      installPhase = ''
        export HOME=$(mktemp -d)

        pnpm config set store-dir $out
        pnpm install --frozen-lockfile --ignore-script

        rm -rf $out/v3/tmp
        for f in $(find $out -name "*.json"); do
          sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
          jq --sort-keys . $f | sponge $f
        done
      '';

      dontBuild = true;
      dontFixup = true;
      outputHashMode = "recursive";
      outputHash = "sha256-m+ue2KnAppgJtVQIfcgQ7MEvMePlsqpBquPDP25StUY=";
    };

  nativeBuildInputs = [
    copyDesktopItems
    nodePackages.pnpm
    nodePackages.nodejs
    makeWrapper
    python3
    pkg-config
  ];

  buildInputs = [
    glib
    vips
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)
    export NODE_OPTIONS = "--max_old_space_size=4096"

    cp -Tr "$pnpmDeps" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm install --offline --frozen-lockfile --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  postBuild = ''
    pnpm build --reporter=ndjson
  '';

  installPhase =
    let
      libPath = lib.makeLibraryPath ([
        jemalloc
        ffmpeg-headless
        stdenv.cc.cc.lib
      ]);
    in
    ''
      runHook preInstall

      mkdir -p $out/data

      mkdir -p $out/data/packages/client
      ln -s /var/lib/sharkey $out/data/files
      ln -s /run/sharkey $out/data/.config
      cp -r locales node_modules built fluent-emojis tossface-emojis sharkey-assets packages package.json pnpm-workspace.yaml $out/data

      # https://gist.github.com/MikaelFangel/2c36f7fd07ca50fac5a3255fa1992d1a

      makeWrapper ${nodePackages.pnpm}/bin/pnpm $out/bin/sharkey \
        --run $out/data
        --prefix LD_LIBRARY_PATH : ${libPath} \
        --prefix NODE_ENV : production
        --add-flags migrateandstart

      runHook postInstall
    '';

  passthru = {
    inherit (finalAttrs) pnpmDeps;
  };

  meta = with lib; {
    description = "🌎 A Sharkish microblogging platform 🚀";
    homepage = "https://joinsharkey.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aprl ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "sharkey";
  };
})


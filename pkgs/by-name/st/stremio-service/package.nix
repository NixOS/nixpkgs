{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,

  pkg-config,
  makeBinaryWrapper,
  desktop-file-utils,
  librsvg,

  openssl,
  glib,
  gtk3,

  libayatana-appindicator,
  jellyfin-ffmpeg, # stremio docs: "We use a specific version of ffmpeg-jellyfin"
  nodejs,
  procps,
}:
let
  # if updating this package, make sure this matches
  # the version specified in Cargo.toml's package.metadata.server
  server = fetchurl rec {
    pname = "stremio-server";
    version = "4.20.17";
    url = "https://dl.strem.io/server/v${version}/desktop/server.js";
    hash = "sha256-Vno5e7EbeIVxvxdQ/QXdeJJ/l77Ayd3qptnMHszuOSI=";
    meta.license = lib.licenses.unfree;
  };
  os = if stdenv.hostPlatform.isDarwin then "macos" else stdenv.hostPlatform.parsed.kernel.name;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-service";
  version = "0.1.21";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-service";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aHkPtfkwe9/ulRb9ZjRd/7/r4xQSTZXF4I4Yb2rLeLY=";
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    librsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    desktop-file-utils
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3.dev
    glib
  ];

  cargoHash = "sha256-5y7CQmIyNBe8DzyDPAiI4I7SznL/zJG0nT7s8X02ZJ0=";
  buildFeatures = [
    "offline-build"
    "bundled"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # fix desktop file path
    substituteInPlace ./src/constants.rs \
      --replace-fail "/usr/share/applications" "${placeholder "out"}/share/applications";
  '';

  preBuild = ''
    # run pre-build checks
    # check for server.js version mismatch
    server_version=$(sed -n '/package.metadata.server/,$p' Cargo.toml | grep -m 1 'version =' | awk -F'"' '{print $2}');
    if [ "$server_version" != "v${finalAttrs.passthru.server.version}" ]; then
      echo "Server version mismatch: expected $server_version, got v${finalAttrs.passthru.server.version}"
      exit 1
    fi

    # replace binary nodejs/ffmpeg with symlinks to the system versions
    rm -rf ./resources/bin/${os}/{ffmpeg,ffprobe,stremio-runtime}
    ln -s ${jellyfin-ffmpeg}/bin/ffmpeg ./resources/bin/${os}/ffmpeg
    ln -s ${jellyfin-ffmpeg}/bin/ffprobe ./resources/bin/${os}/ffprobe
    ln -s ${nodejs}/bin/node ./resources/bin/${os}/stremio-runtime

    # create server.js symlink and server_version.txt
    ln -s ${finalAttrs.passthru.server} ./resources/bin/${os}/server.js
    echo "v${finalAttrs.passthru.server.version}" > ./resources/bin/${os}/server_version.txt
  '';

  dontCargoInstall = true;
  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # install desktop/icon files
      mkdir -p $out/share/{applications,metainfo}
      install -Dm 644 \
        ./resources/com.stremio.service.desktop \
        $out/share/applications/com.stremio.service.desktop;
      install -Dm 644 \
        ./resources/com.stremio.service.metainfo.xml \
        $out/share/metainfo/com.stremio.service.metainfo.xml;
      install -Dm 644 \
        ./resources/com.stremio.service.svg \
        $out/share/icons/hicolor/scalable/apps/com.stremio.service.svg;

      # render non-scalable icons
      for size in 16 32 64 128 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        rsvg-convert \
          -w $size -h $size \
          ./resources/com.stremio.service.svg \
          -o $out/share/icons/hicolor/"$size"x"$size"/apps/com.stremio.service.png
      done

      # patch desktop file
      desktop-file-edit \
        --set-key="Exec" --set-value="stremio-service" \
        --set-key="TryExec" --set-value="stremio-service" \
        $out/share/applications/com.stremio.service.desktop
    ''}

    # install data directory (/share/stremio-service)
    mkdir -p $out/{bin,share/stremio-service}
    cp -r ./resources/bin/${os}/* $out/share/stremio-service

    # locate compiled binary dynamically across architectures/cross-compilation
    compiled_binary=$(find target -name "stremio-service" -type f -path "*/release/*" | head -n 1)
    install -Dm 755 "$compiled_binary" $out/share/stremio-service/stremio-service;
    install -Dm 644 ./LICENSE.md $out/share/stremio-service/LICENSE.md;

    # create /bin wrapper
    makeBinaryWrapper \
      $out/share/stremio-service/stremio-service \
      $out/bin/stremio-service \
      --add-flags "--skip-updater" \
      --set NODE_ENV production \
      --prefix PATH : "${lib.makeBinPath [ procps ]}" \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}"
      ''}

    runHook postInstall
  '';

  checkFlags = [
    # Skip test that fails in hermetic build sandbox due to missing git repository history
    "--skip=copyright"
  ];

  passthru = {
    inherit server;
  };

  meta = {
    mainProgram = "stremio-service";
    description = "Modern media center that gives you the freedom to watch everything you want (Service only)";
    homepage = "https://www.stremio.com/";
    license =
      with lib.licenses;
      AND [
        gpl2Only
        unfree # server.js is unfree
      ];
    maintainers = with lib.maintainers; [
      griffi-gh
      rachalaraj
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})

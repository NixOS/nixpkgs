{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libgcc,
  fontconfig,
  lttng-ust_2_12,
  icu,
  xorg,
  openssl,
  vulkan-loader,
  libGL,
  makeWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  # TODO: build from source; i gave up on it for now
  # (my previous attempt can be found at the griffi-gh:pixieditor-src branch)
  # - nixpkgs seemingly does not support building .NET projects that use workloads
  #   PixiEditor requires `wasi-experimental` and `wasm-tools`
  # - `wasi-sdk` is not packaged on nixpkgs, although there's a binary build avaiable here:
  #   https://github.com/WebAssembly/wasi-sdk/releases/tag/wasi-sdk-25
  #   havent tested if it works yet
  # - i ran into issues with deps.json (failed to create symbolic link)

  pname = "pixieditor";
  version = "2.0.0.82-dev";

  src = fetchurl {
    url = "https://github.com/PixiEditor/PixiEditor-development-channel/releases/download/${finalAttrs.version}/PixiEditor-${lib.removeSuffix "-dev" finalAttrs.version}-amd64-linux.deb";
    sha256 = "sha256-QfeGNidm+MXYOs/yLyngWrYbaD+7CGLaO6NN7O3Xx04=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libgcc.lib
    fontconfig.lib
    lttng-ust_2_12
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv ./usr/{lib,share} "$out"
    ln -s "$out/lib/pixieditor/LICENSE" "$out/bin/LICENSE"
    makeWrapper $out/lib/pixieditor/PixiEditor $out/bin/pixieditor \
      --prefix PATH : "$out/lib/pixieditor" \
      --prefix LD_LIBRARY_PATH : "$out/lib/pixieditor" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (
          finalAttrs.buildInputs
          ++ [
            vulkan-loader
            libGL
            xorg.libX11
            xorg.libICE
            xorg.libSM
            xorg.libXi
            xorg.libXcursor
            xorg.libXext
            xorg.libXrandr
            openssl
            icu
          ]
        )
      }" \
      --set DOTNET_ROOT "$out/lib/pixieditor"

    runHook postInstall
  '';

  # strip breaks .NET binaries
  dontStrip = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universal editor for all your 2D needs";
    longDescription = ''
      PixiEditor is a universal 2D platform that aims to provide you with tools and features for all your 2D needs.
      Create beautiful sprites for your games, animations, edit images, create logos. All packed in an eye-friendly dark theme
    '';
    homepage = "https://pixieditor.net/";
    # "https://github.com/PixiEditor/PixiEditor-development-channel/releases/tag/${finalAttrs.version}";
    changelog = "https://forum.pixieditor.net/tags/c/open-beta/7/changelog";
    license = lib.licenses.lgpl3Only;
    mainProgram = "pixieditor";
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
  };
})

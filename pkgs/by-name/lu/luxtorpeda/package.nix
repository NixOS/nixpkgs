{
  lib,
  stdenv,
  fetchzip,
  writeScript,
  autoPatchelfHook,
  xz,
  libGL,
  libx11,
  libxcursor,
  libxinerama,
  libxext,
  libxrandr,
  libxrender,
  libxi,
  libxfixes,
  libxkbcommon,
  vulkan-loader,
  alsa-lib,
  libpulseaudio,
  udev,
  dbus,
  speechd,
  fontconfig,
  steamDisplayName ? "Luxtorpeda",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "luxtorpeda";
  version = "76.2.0";

  src = fetchzip {
    url = "https://github.com/luxtorpeda-dev/luxtorpeda/releases/download/v${finalAttrs.version}/luxtorpeda-v${finalAttrs.version}.tar.xz";
    hash = "sha256-l1q+/+5TvSIvyEkVGNRKnGWygRjqXzj4bKfZfk9Zrd4=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    xz
    libGL
    libx11
    libxcursor
    libxinerama
    libxext
    libxrandr
    libxrender
    libxi
    libxfixes
    libxkbcommon
    vulkan-loader
    alsa-lib
    libpulseaudio
    udev
    dbus
    speechd
    fontconfig
  ];

  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir -p $steamcompattool
    cp -r . $steamcompattool/

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "Luxtorpeda" "${steamDisplayName}"
  '';

  passthru.updateScript = writeScript "update-luxtorpeda" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://api.github.com/repos/luxtorpeda-dev/luxtorpeda/releases"
    version="$(curl -sL ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output | sed 's/^v//')"
    update-source-version luxtorpeda "$version"
  '';

  meta = {
    description = "Steam Play compatibility tool to run games using native Linux engines (for use with programs.steam.extraCompatPackages)";
    homepage = "https://github.com/luxtorpeda-dev/luxtorpeda";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ neovim-btw ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

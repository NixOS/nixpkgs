{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  nspr,
  nss,
  libgbm,
  alsa-lib,
  libseccomp,
  libcap_ng,
  libglvnd,
  fetchurl,
}:
let
  platforms = {
    "x86_64-linux" = {
      platform = "amd64";
      hash = "sha256-VjyN+O47lXyiNBFZgDhulgAH7Yz8jMBMd9WKjUP2wBg=";
    };
    "aarch64-linux" = {
      platform = "arm64";
      hash = "sha256-R1ms8ZtqyYH7rlzRwlqCjunG6Vz6nqTLjJzNfC/FOHE=";
    };
  };
  source = builtins.getAttr stdenv.hostPlatform.system platforms;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "claude-desktop";
  version = "1.17377.0";

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_${source.platform}.deb";
    hash = source.hash;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    nspr
    nss
    libgbm
    alsa-lib
    libseccomp.lib
    libcap_ng
  ];

  unpackPhase = ''
    ar x $src
    tar --no-same-permissions --no-same-owner -xf data.tar.xz
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out/
  '';

  postFixup = ''
    wrapProgram $out/bin/claude-desktop \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]}
  '';

  dontConfigure = true;
  dontBuild = true;
  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Desktop application for Claude.ai";
    homepage = "https://claude.ai";
    license = lib.licenses.unfree;
    mainProgram = "claude-desktop";
    maintainers = with lib.maintainers; [ AhmedAmr ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

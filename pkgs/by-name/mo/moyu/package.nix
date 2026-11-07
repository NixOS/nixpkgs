{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  clang,
  lld,
  makeBinaryWrapper,
  libopus,
  alsa-lib,
  udev,
  wayland,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moyu";
  version = "0.15.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Icemic";
    repo = "moyu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GoCcFhUbWB5NBVKgqjejBGlyElbmeD4ry/dcbegb/1Y=";
  };

  cargoHash = "sha256-Jef2CjSuJISGHyrVpXkuG8PzP+C+xNDE3SlL8ldsiAo=";

  nativeBuildInputs = [
    pkg-config
    clang # libquickjs-ng-sys
    lld
    rustPlatform.bindgenHook
    makeBinaryWrapper
  ];

  buildInputs = [
    libopus # audiopus_sys
    alsa-lib
    udev
  ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          finalAttrs.buildInputs
          ++ [
            wayland
            libxkbcommon
            libGL
            libx11
            libxcursor
            libxi
          ]
        )
      }
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Cross-platform visual novel engine";
    homepage = "https://momoyu.ink/";
    downloadPage = "https://github.com/Icemic/moyu/releases";
    license = lib.licenses.mpl20;
    mainProgram = "moyu";
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})

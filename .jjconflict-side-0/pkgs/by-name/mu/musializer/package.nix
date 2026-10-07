{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  libx11,
  libxcursor,
  libxrandr,
  libxinerama,
  libxi,
  libGL,
  alsa-lib,
  libpulseaudio,
  ffmpeg,
  nix-update-script,
}:

let
  xorgDeps = [
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxi
  ];

  # Audio backends are loaded with dlopen by miniaudio at runtime
  runtimeLibs = xorgDeps ++ [
    libGL
    alsa-lib
    libpulseaudio
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "musializer";
  version = "alpha2";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "musializer";
    tag = finalAttrs.version;
    hash = "sha256-EKmdv1gVrsajyjFnV6hngGnct4NAZ5SwtPHA43VZDlI=";
  };

  postPatch = ''
    substituteInPlace src/{plug.c,musializer.c} \
      --replace-fail './resources' "$out/share"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = xorgDeps;

  propagatedUserEnvPkgs = [ ffmpeg ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE"; # Ensure `ppoll` is available

  configurePhase = ''
    runHook preConfigure

    $CC --output nob nob.c

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ./nob

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/musializer -t $out/bin
    wrapProgram $out/bin/musializer \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}

    cp --recursive resources $out/share

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Music Visualizer";
    longDescription = ''
      The project aims to make a tool for creating beautiful music
      visualizations and rendering high quality videos of them.
    '';
    homepage = "https://github.com/tsoding/musializer";
    changelog = "https://github.com/tsoding/musializer/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "musializer";
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
})

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,

  bzip2,
  libGL,
  libX11,
  libXcursor,
  libxkbcommon,
  libXi,
  moltenvk,
  sdl3,
  wayland,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gopher64";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "gopher64";
    repo = "gopher64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDFtPISV17jQMECBIqYbbGhZpjYXuNnOq7EiEVtSzgc=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/GIT_REV
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  cargoPatches = [
    # upstream rebuilds SDL3 from source
    # this patch makes it use the SDL3 library provided by nixpkgs
    ./use-sdl3-via-pkg-config.patch

    # make the build script use the @GIT_REV@ string that will be substituted in the logic below
    ./set-git-rev.patch

    # enum CicType is not used, but dead code is treated as an error
    ./allow-unused-type.patch
  ];

  postPatch = ''
    # use the file generated in the fetcher to supply the git revision
    substituteInPlace build.rs \
      --replace-fail "@GIT_REV@" $(cat GIT_REV)
  '';

  cargoHash = "sha256-31kEYwlDA6iYcwPZyQU4gM/VLfPNeYcDKhhBqzNp/QE=";

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    sdl3
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
  ];

  # these are dlopen-ed during runtime
  runtimeDependencies = lib.optionalString stdenv.hostPlatform.isLinux [
    libGL
    libxkbcommon

    # for X11
    libX11
    libXcursor
    libXi

    # for wayland
    wayland
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/gopher64 --add-rpath ${lib.makeLibraryPath finalAttrs.runtimeDependencies}
  '';

  meta = {
    changelog = "https://github.com/gopher64/gopher64/releases/tag/${finalAttrs.src.tag}";
    description = "N64 emulator written in Rust";
    homepage = "https://github.com/gopher64/gopher64";
    license = lib.licenses.gpl3Only;
    mainProgram = "gopher64";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})

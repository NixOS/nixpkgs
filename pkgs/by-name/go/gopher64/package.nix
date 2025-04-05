{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,

  bzip2,
  sdl3,
  zstd,

  moltenvk,

  libGL,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "gopher64";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "gopher64";
    repo = "gopher64";
    tag = "v${version}";
    hash = "sha256-uzN/v6ZxDUMhfWxQQCbz5tAa7YBQ82APG9sc9F/9Jc8=";
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
  ];

  postPatch = ''
    # use the file generated in the fetcher to supply the git revision
    substituteInPlace build.rs \
      --replace-fail "@GIT_REV@" $(cat GIT_REV)
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-A8M/oQaNz+rBypC1kKldDVWZ8rHV8pIU2qJlIwvRQ8o=";

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      bzip2
      sdl3
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      moltenvk
    ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/gopher64 --add-rpath ${
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        wayland
      ]
    }
  '';

  meta = {
    changelog = "https://github.com/gopher64/gopher64/releases/tag/${src.tag}";
    description = "N64 emulator written in Rust";
    homepage = "https://github.com/gopher64/gopher64";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "gopher64";
  };
}

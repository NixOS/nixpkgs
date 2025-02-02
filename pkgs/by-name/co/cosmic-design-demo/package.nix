{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  just,
  pkg-config,
  expat,
  libxkbcommon,
  fontconfig,
  freetype,
  wayland,
  makeBinaryWrapper,
  cosmic-icons,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-design-demo";
  version = "unstable-2024-01-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "d58cfad46f2982982494fce27fb00ad834dc8992";
    hash = "sha256-nWkiaegSjxgyGlpjXE9vzGjiDORaRCSoZJMDv0jtvaA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-czfDtiSEmzmcLfpqv0/8sP8zDAEKh+pkQkGXdd5NskM=";

  nativeBuildInputs = [
    cmake
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    expat
    fontconfig
    freetype
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--unstable"
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-design-demo"
  ];

  postInstall = ''
    wrapProgram "$out/bin/cosmic-design-demo" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share"
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-design-demo";
    description = "Design Demo for the COSMIC Desktop Environment";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-design-demo";
  };
}

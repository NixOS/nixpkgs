{
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  python3,
  libGL,
  freetype,
  expat,
  xorg,
  rustPlatform,
  nix-update-script,
  enableVST2 ? false,
}:
let
  version = "0.9.1";
in
rustPlatform.buildRustPackage {
  pname = "octasine";
  inherit version;

  src = fetchFromGitHub {
    owner = "greatest-ape";
    repo = "octasine";
    tag = "v${version}";
    hash = "sha256-Vr1L5B7dF0pJieE/Zww/T6XbZadWMK5Fdq66qRfQFF0=";
  };

  cargoHash = "sha256-I+iZxngM8o4BIzjpowjf8l2m6MSY/NSSOd4TcYFjrIc=";

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ];

  buildInputs = [
    libGL
    freetype
    expat
    xorg.libX11
    xorg.libXcursor
    xorg.libxcb
    xorg.xcbutilwm
  ];

  buildPhase = ''
    runHook preBuild

    cargo xtask bundle -p octasine --release --features "clap"

    ${lib.optionalString enableVST2 ''
      cargo xtask bundle -p octasine --release --features "vst2"
    ''}

    cd octasine-cli
    cargo build --release
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/clap
    install -Dm755 target/bundled/octasine.clap $out/lib/clap


    ${lib.optionalString enableVST2 ''
      mkdir -p $out/lib/vst
      install -Dm755 target/bundled/octasine.so $out/lib/vst
    ''}

    mkdir -p $out/bin
    install -Dm755 target/release/octasine-cli $out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Frequency modulation synthesizer plugin (VST2, CLAP).";
    homepage = "https://github.com/greatest-ape/OctaSine";
    mainProgram = "octasine-cli";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.agpl3Only ] ++ lib.optional enableVST2 lib.licenses.unfree;
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}

{
  lib,
  stdenv,
  stdenvAdapters,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  wayland,

  withMoldLinker ? stdenv.targetPlatform.isLinux,
}:

rustPlatform.buildRustPackage.override
  { stdenv = if withMoldLinker then stdenvAdapters.useMoldLinker stdenv else stdenv; }
  rec {
    pname = "cosmic-bg";
    version = "1.0.0-alpha.6";

    src = fetchFromGitHub {
      owner = "pop-os";
      repo = pname;
      rev = "epoch-${version}";
      hash = "sha256-4b4laUXTnAbdngLVh8/dD144m9QrGReSEjRZoNR6Iks=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-GLXooTjcGq4MsBNnlpHBBUJGNs5UjKMQJGJuj9UO2wk=";

    postPatch = ''
      substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"
    '';

    nativeBuildInputs = [
      just
      pkg-config
      makeBinaryWrapper
    ];
    buildInputs = [
      libxkbcommon
      wayland
    ];

    dontUseJustBuild = true;

    justFlags = [
      "--set"
      "prefix"
      (placeholder "out")
      "--set"
      "bin-src"
      "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
    ];

    env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
      lib.optionalString withMoldLinker "-C link-arg=-fuse-ld=mold";

    postInstall = ''
      wrapProgram $out/bin/cosmic-bg \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
    '';

    meta = with lib; {
      homepage = "https://github.com/pop-os/cosmic-bg";
      description = "Applies Background for the COSMIC Desktop Environment";
      license = licenses.mpl20;
      maintainers = with maintainers; [ nyabinary ];
      platforms = platforms.linux;
      mainProgram = "cosmic-bg";
    };
  }

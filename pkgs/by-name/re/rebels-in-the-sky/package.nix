{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchpatch,
  cmake,
  pkg-config,
  alsa-lib,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  withRadio ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "rebels-in-the-sky";
  version = "1.0.29";

  src = fetchFromGitHub {
    owner = "ricott1";
    repo = "rebels-in-the-sky";
    tag = "v${version}";
    hash = "sha256-rWBaD4nxSmr1RZRbc51Sz9Xl2Te2yv4HNuFqWj8KayM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    # Some tests write to home dir
    writableTmpDirAsHomeHook
  ];
  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;
  nativeInstallCheckInputs = [ versionCheckHook ];

  patches = lib.optional (!withRadio) ./disable-radio.patch ++ [
    # https://github.com/ricott1/rebels-in-the-sky/pull/25
    (fetchpatch {
      url = "https://github.com/ricott1/rebels-in-the-sky/commit/31778fee783637fe8af09f71754f35c5d15b800a.patch";
      hash = "sha256-PO/aY+fB72gQpxE5eaIP/s4xevfQ/Ac1TH5ZEKwpw1I=";
    })
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZRxq6/mgXZ33o1AEHnSOt4HJAI1y+F+ysVNvvbb9M28=";

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "P2P terminal game about spacepirates playing basketball across the galaxy";
    longDescription = ''
      It's the year 2101. Corporations have taken over the world. The only way to be free is
      to join a pirate crew and start plundering the galaxy. The only means of survival is
      to play basketball.

      Now it's your turn to go out there and make a name for yourself. Create your crew and
      start wandering the galaxy in search of worthy basketball opponents.
    '';
    homepage = "https://frittura.org/";
    changelog = "https://github.com/ricott1/rebels-in-the-sky/releases/tag/v${version}";
    license =
      with lib.licenses;
      [ gpl3Only ]
      # The original game soundtrack was generated using AI so its licensing is unclear.
      # I couldn't find licensing information regarding other radio stations, so I'm
      # assuming they're nonfree.
      ++ lib.optional withRadio unfree;
    maintainers = with lib.maintainers; [ marcin-serwin ];
    mainProgram = "rebels";
  };
}

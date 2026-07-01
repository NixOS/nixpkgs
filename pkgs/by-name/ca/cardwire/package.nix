{
  lib,
  rustPlatform,
  fetchFromGitHub,
  hwdata,
  libbpf,
  clang,
  pkg-config,
  nixosTests,
  makeWrapper,
  udev,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cardwire";
  version = "0.10.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opengamingcollective";
    repo = "cardwire";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dN9F6nd7ypOnxHWC7rSu3oskDhBSN6QqLxRrWYW/9wI=";
  };
  cargoHash = "sha256-WStOjlZSh8/MHyTEo8Yd4SfMG7flQ7Uo/hBDt2clnpQ=";

  postPatch = ''
    substituteInPlace crates/cardwire-daemon/src/core/pci/pci_device.rs \
      --replace-fail "/usr/share/hwdata/pci.ids" "${hwdata}/share/hwdata/pci.ids"
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    clang
  ];

  buildInputs = [
    libbpf
    udev
  ];

  postInstall = ''
    install -Dm444 ./assets/com.github.opengamingcollective.cardwire.conf \
      $out/share/dbus-1/system.d/com.github.opengamingcollective.cardwire.conf

    wrapProgram $out/bin/cardwired \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          udev
        ]
      }
  '';

  passthru.tests.cardwire = nixosTests.cardwire;

  meta = {
    description = "GPU manager for laptop and workstation";
    platforms = [ "x86_64-linux" ];
    homepage = "https://opengamingcollective.github.io/cardwire/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      luytan
    ];
  };
})

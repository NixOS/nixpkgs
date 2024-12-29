{
  fetchFromGitHub,
  lib,
  libcosmicAppHook,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-reader";
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "9f62f5455d7faea844b55f3495e12b1e47bb8111";
    hash = "sha256-qgD/waojjVLRTe1aasUlwGH042tRnesplj4hSGlb+Qs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kjZeqkFgkTZI66NXNtusFRYGQBcZa2JwP6YeTRJSSDM=";

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-reader";
    description = "PDF reader for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-reader";

    maintainers = with maintainers; [
      thefossguy
    ];
  };
}

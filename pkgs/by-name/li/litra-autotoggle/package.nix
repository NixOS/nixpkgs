{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "litra-autotoggle";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "timrogers";
    repo = "litra-autotoggle";
    tag = "v${version}";
    hash = "sha256-CoP9t8uvErvP3sU51pfsjsY/xp/zXNVcgXP8WmONz60=";
  };

  cargoHash = "sha256-MCabivlj8ye8WKMFJ9oP5+J72D8Ib0xlYEOjLCUKjYg=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp *.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "Automatically sync your Logitech Litra light with your webcam";
    homepage = "https://github.com/timrogers/litra-autotoggle";
    license = lib.licenses.mit;
    mainProgram = "litra-autotoggle";
    maintainers = with lib.maintainers; [
      sh3rm4n
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}

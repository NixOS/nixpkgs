{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  udev,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "litra";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "timrogers";
    repo = "litra-rs";
    tag = "v${version}";
    hash = "sha256-0BwtC2gFdt8rri5WGGdqMThPdax/UrZRfpCykWMydhA=";
  };

  cargoHash = "sha256-0T2oq+f7KwNn2nZVEsFBDEt2sRHe/Loq4zVx6jT7/us=";

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
    description = "Control your Logitech Litra light from the command line";
    homepage = "https://github.com/timrogers/litra-rs";
    license = lib.licenses.mit;
    mainProgram = "litra";
    maintainers = with lib.maintainers; [
      sh3rm4n
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}

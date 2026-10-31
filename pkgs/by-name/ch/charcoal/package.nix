{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  installShellFiles,
  openssl,
  alsa-lib,
  didyoumean,
  nix-update-script,
  withAutocorrect ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "charcoal";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "LighghtEeloo";
    repo = "charcoal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cEwYyPS3KBZVzeZERI5jT1NR1xYnc/FZPZCi3gwyAeg=";
  };

  cargoHash = "sha256-ySFwL/y1mthVuie77vh9EjVLfVqIezjz0HoQ5CBG6nk=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals withAutocorrect [
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  postInstall = lib.optionalString withAutocorrect ''
    wrapProgram $out/bin/charcoal \
      --prefix PATH : ${lib.makeBinPath [ didyoumean ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line dictionary using youdao dict API";
    homepage = "https://github.com/LighghtEeloo/charcoal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gorgeous-patrick ];
    mainProgram = "charcoal";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

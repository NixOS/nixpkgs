{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  wayland,
  rtk,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "maki";
  version = "0.5.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tontinton";
    repo = "maki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mJFvNpbtYPb0wSsHvKYGFnk48tK5L9vVGg9elzEgXRA=";
  };

  cargoHash = "sha256-l8Lu+7hQzZ9D5Vhs0R+0J6EtgO07UM/9IeAy/224zaU=";

  nativeBuildInputs = [
    curl
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    curl
    openssl
    zlib
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # Uses https://github.com/rtk-ai/rtk if it is installed in $PATH
  postInstall = ''
    wrapProgram $out/bin/maki \
      --prefix PATH : "${lib.makeBinPath [ rtk ]}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient AI coding agent extendable by neovim-like Lua plugins";
    downloadPage = "https://github.com/tontinton/maki";
    homepage = "https://maki.sh/";
    changelog = "https://github.com/tontinton/maki/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "maki";
  };
})

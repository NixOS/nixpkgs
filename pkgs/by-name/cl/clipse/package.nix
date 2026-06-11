{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  enableWayland ? stdenv.hostPlatform.isLinux,
  enableX11 ? false,
  libpng,
  libx11,
  libxi,
  libxkbcommon,
  libxtst,
  pkg-config,
  xclip,
  xinput,
  xkbcomp,
  xkbutils,
  xsel,
}:

assert lib.assertMsg (
  stdenv.hostPlatform.isLinux -> (lib.xor enableX11 enableWayland)
) "Exactly one of enableWayland, enableX11 must be true";

buildGoModule (finalAttrs: {
  pname = "clipse${lib.optionalString enableX11 "-x11"}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iDMHEhYuxspBYG54WivnVj2GfMxAc5dcrjNxtAMhsck=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  vendorHash = "sha256-LxwST4Zjxq6Fwc47VeOdv19J3g/DHZ7Fywp2ZvVR06I=";

  tags =
    if stdenv.hostPlatform.isDarwin then
      [ "darwin" ]
    else if enableWayland then
      [ "wayland" ]
    else if enableX11 then
      [ "linux" ]
    else
      [ ];

  env = {
    CGO_ENABLED = if enableX11 || stdenv.hostPlatform.isDarwin then "1" else "0";
  };

  nativeBuildInputs = lib.optionals enableX11 [
    pkg-config
  ];

  buildInputs = lib.optionals enableX11 [
    libpng
    libx11
    libxi
    libxkbcommon
    libxtst
    xclip
    xinput
    xkbcomp
    xkbutils
    xsel
  ];

  proxyVendor = true;

  meta = {
    changelog = "https://github.com/savedra1/clipse/blob/main/CHANGELOG.md";
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = with lib.maintainers; [
      magicquark
      savedra1
    ];
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  enableWayland ? stdenv.hostPlatform.isLinux,
  enableX11 ? false,
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

  vendorHash = "sha256-rq+2UhT/kAcYMdla+Z/11ofNv2n4FLvpVgHZDe0HqX4=";

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

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = [ lib.maintainers.savedra1 ];
  };
})

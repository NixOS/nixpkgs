{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  enableWayland ? true,
  enableX11 ? false,
}:

let
  pname = "clipse";
  version = "1.2.1";

  tags =
    if stdenv.hostPlatform.isDarwin then
      [ "darwin" ]
    else if enableWayland then
      [ "wayland" ]
    else if enableX11 then
      [ "linux" ]
    else
      [ ];

  cgoEnabled = enableX11 || stdenv.hostPlatform.isDarwin;

  packageName = if enableX11 then "${pname}-x11" else pname;
in
(
  assert lib.assertMsg (
    stdenv.hostPlatform.isLinux -> (lib.xor enableX11 enableWayland)
  ) "Exactly one of enableWayland, enableX11 must be true";

  buildGoModule {
    pname = packageName;
    inherit version;

    src = fetchFromGitHub {
      owner = "savedra1";
      repo = "clipse";
      rev = "v${version}";
      hash = "sha256-iDMHEhYuxspBYG54WivnVj2GfMxAc5dcrjNxtAMhsck=";
    };

    vendorHash = "sha256-rq+2UhT/kAcYMdla+Z/11ofNv2n4FLvpVgHZDe0HqX4=";

    inherit tags;

    env = {
      CGO_ENABLED = if cgoEnabled then "1" else "0";
    };

    meta = {
      description = "Useful clipboard manager TUI for Unix";
      homepage = "https://github.com/savedra1/clipse";
      license = lib.licenses.mit;
      mainProgram = "clipse";
      maintainers = [ lib.maintainers.savedra1 ];
    };
  }
)

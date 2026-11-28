{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "matrix-rig";
  version = "0-unstable-2025-10-12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "matrix-rig";
    rev = "db4f5bbbac3bc7132d1dc35c09350b5360b180d4";
    hash = "sha256-1o17wOv20GefUMeZBafAaX9/nvqMwbMcW8kutwYFe7A=";
  };

  vendorHash = "sha256-Ovpb2exTFWP7BuQIo+e/CPqgYOE/SYL1K7gUygZVK8A=";

  meta = {
    description = "Vanity room ID generator for Matrix room v12 (MSC4291)";
    homepage = "https://github.com/tulir/matrix-rig";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ logn ];
  };
})

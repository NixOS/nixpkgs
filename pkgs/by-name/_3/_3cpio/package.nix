{
  fetchFromGitHub,
  lib,
  lz4,
  lzop,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "3cpio";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "bdrung";
    repo = "3cpio";
    tag = version;
    hash = "sha256-FuxnzRGhunLM90RuwCVVuRtNmjV2jS0e8BxwrOxLM8Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m559ykuXYqvLkzwBx3Ndji98b33uhcVLn7/wtCWvpEQ=";

  nativeCheckInputs = [
    lz4
    lzop
  ];

  cargoTestFlags = [ "-- --skip=test_write_directory_with_setuid" ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage initrd cpio archives";
    homepage = "https://github.com/bdrung/3cpio";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "3cpio";
  };
}

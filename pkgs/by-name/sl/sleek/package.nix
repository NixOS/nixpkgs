{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sleek";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nrempel";
    repo = "sleek";
    rev = "v${version}";
    hash = "sha256-VQ0LmKhFsC12qoXCFHxtV5E+J7eRvZMVH0j+5r8pDk8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vq4e/2+YfMw2n8ZMYPa/3HtNk9pCtXWN/u1MzhBkZJQ=";

  meta = with lib; {
    description = "CLI tool for formatting SQL";
    homepage = "https://github.com/nrempel/sleek";
    license = licenses.mit;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "sleek";
  };
}

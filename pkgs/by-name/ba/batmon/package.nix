{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "batmon";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "6543";
    repo = "batmon";
    tag = "v${version}";
    hash = "sha256-+kjDNQKlaoI5fQ5FqYF6IPCKeE92WKxIhVCKafqfE0o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0SXb8jBAYKnNFguamSMosPE6gH9aUzydF16w3SLhOU4=";

  meta = with lib; {
    description = "Interactive batteries viewer";
    longDescription = ''
      An interactive viewer, similar to top, htop and other *top utilities,
      but about the batteries installed in your notebook.
    '';
    homepage = "https://github.com/6543/batmon/";
    changelog = "https://github.com/6543/batmon/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "batmon";
    platforms = with platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    maintainers = with maintainers; [ _6543 ];
  };
}

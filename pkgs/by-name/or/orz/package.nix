{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rust-cbindgen,
}:

rustPlatform.buildRustPackage {
  pname = "orz";
  version = "1.6.2-unstable-2024-11-08";

  src = fetchFromGitHub {
    owner = "richox";
    repo = "orz";
    rev = "c828a50f18a309d4715741056db74941e6a98867";
    hash = "sha256-PVso4ufBwxhF1yhzIkIwSbRJdnH9h8gn3nreWQJDMn4=";
  };

  cargoHash = "sha256-vbhK4jHNhCI1nFv2pVOtjlxQe+b7NMP14z2Tk+no8Vs=";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    rust-cbindgen
  ];

  postInstall = ''
    cbindgen -o $dev/include/orz.h

    mkdir -p $lib
    mv $out/lib "$lib"
  '';

  meta = with lib; {
    description = "High performance, general purpose data compressor written in rust";
    homepage = "https://github.com/richox/orz";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "orz";
  };
}

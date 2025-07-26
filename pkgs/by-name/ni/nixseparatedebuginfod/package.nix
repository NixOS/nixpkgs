{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libarchive,
  openssl,
  rust-jemalloc-sys,
  sqlite,
  pkg-config,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixseparatedebuginfod";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nixseparatedebuginfod";
    rev = "v${version}";
    hash = "sha256-sVQ6UgQvSTEIxXPxISeTI9tqAdJlxQpLxq1h4I31r6k=";
  };

  cargoHash = "sha256-vaCmRr1hXF0BSg/dl3LYyd7c1MdPKIv6KgDgGEzqqJQ=";

  # tests need a working nix install with access to the internet
  doCheck = false;

  buildInputs = [
    libarchive
    openssl
    rust-jemalloc-sys
    sqlite
  ];

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests = {
      inherit (nixosTests) nixseparatedebuginfod;
    };
  };

  meta = with lib; {
    description = "Downloads and provides debug symbols and source code for nix derivations to gdb and other debuginfod-capable debuggers as needed";
    homepage = "https://github.com/symphorien/nixseparatedebuginfod";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.linux;
    mainProgram = "nixseparatedebuginfod";
  };
}

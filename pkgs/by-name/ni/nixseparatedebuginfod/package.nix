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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nixseparatedebuginfod";
    rev = "v${version}";
    hash = "sha256-z20KvspXUIr6PtVozcQDkiIzYvVAWQ9PGAZJM1eqrlY=";
  };

  cargoHash = "sha256-XeeVgHlnVsRlZTx1fQz+r0ajuUZ9oOcvFio+agngDL8=";

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

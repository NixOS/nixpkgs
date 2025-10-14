{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libarchive,
  openssl,
  pkg-config,
  bubblewrap,
  elfutils,
  nix,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixseparatedebuginfod2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nixseparatedebuginfod2";
    tag = "v${version}";
    hash = "sha256-r/lmnYdnqyc0Mx1ZVzebiz8V04bmKb8lJBv/ndIzQYM=";
  };

  cargoHash = "sha256-bj5OOj/PpoBU745hbhN1YqiVBikNIzT6/WrNGklRqy4=";

  buildInputs = [
    libarchive
    openssl
  ];

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [
    bubblewrap
    elfutils
    nix
  ];

  env.OPENSSL_NO_VENDOR = "1";

  passthru.tests = { inherit (nixosTests) nixseparatedebuginfod2; };

  meta = {
    description = "Downloads and provides debug symbols and source code for nix derivations to gdb and other debuginfod-capable debuggers as needed";
    homepage = "https://github.com/symphorien/nixseparatedebuginfod2";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.symphorien ];
    platforms = lib.platforms.linux;
    mainProgram = "nixseparatedebuginfod2";
  };
}

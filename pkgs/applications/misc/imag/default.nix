{ stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, openssl
, pkg-config
, installShellFiles
, Security
, gitMinimal
, utillinuxMinimal
}:

rustPlatform.buildRustPackage rec {
  pname = "imag";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "matthiasbeyer";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f9915f083z5qqcxyavj0w6m973c8m1x7kfb89pah5agryy5mkaq";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;
  checkInputs = [ gitMinimal utillinuxMinimal ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  cargoSha256 = "0n8cw70qh8g4hfwfaxwwxbrrx5hm2z037z8kdhvdpqkxljl9189x";

  checkPhase = ''
    export HOME=$TMPDIR
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"

    # UI tests uses executables directly, so we need to build them before
    # launching the tests
    cargo build
  '' + (
    # CLI uses the presence of a controlling TTY to check if arguments are
    # passed in stdin, or in the command-line, so we use script to create
    # a PTY for us.
    if !stdenv.isDarwin then ''
      script -qfec "cargo test --workspace"
    '' else ''
      script -q "cargo test --workspace"
    ''
  );

  postInstall = ''
    installShellCompletion target/imag.{bash,fish} --zsh target/_imag
  '';

  meta = with stdenv.lib; {
    description = "Commandline personal information management suite";
    homepage = "https://imag-pim.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ Br1ght0ne minijackson ];
    platforms = platforms.unix;
  };
}

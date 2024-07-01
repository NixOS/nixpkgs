{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, curl
, libgit2
, libssh2
, openssl
, zlib
}:

rustPlatform.buildRustPackage {
  pname = "git-series";
  version = "unstable-2019-10-15";

  src = fetchFromGitHub {
    owner = "git-series";
    repo = "git-series";
    rev = "c570a015e15214be46a7fd06ba08526622738e20";
    sha256 = "1i0m2b7ma6xvkg95k57gaj1wpc1rfvka6h8jr5hglxmqqbz6cb6w";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  buildInputs = [
    libgit2
    libssh2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    install -D "$src/git-series.1" "$out/man/man1/git-series.1"
  '';

  meta = with lib; {
    description = "Tool to help with formatting git patches for review on mailing lists";
    longDescription = ''
      git series tracks changes to a patch series over time. git
      series also tracks a cover letter for the patch series,
      formats the series for email, and prepares pull requests.
    '';
    homepage = "https://github.com/git-series/git-series";

    license = licenses.mit;
    maintainers = with maintainers; [ edef vmandela ];
    mainProgram = "git-series";
  };
}

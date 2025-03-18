{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  curl,
  installShellFiles,
  libgit2,
  libssh2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage {
  pname = "git-series";
  version = "0.9.1-unstable-2024-02-02";

  src = fetchFromGitHub {
    owner = "git-series";
    repo = "git-series";
    rev = "9c5d40edec87b79db0c5bac1458aa0e2c8fdeb8e";
    hash = "sha256-DtOR7+vX7efNzYMRJwJTj5cXlFHQwzcS0Gp2feVdea4=";
  };

  cargoHash = "sha256-D83mfaH4iKagGjdX+YhCzva99+dCneHeWPNnkzZB/k0=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ] ++ lib.optionals stdenv.isDarwin [ curl ];

  buildInputs = [
    libgit2
    libssh2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [ curl ];

  env = {
    LIBGIT2_SYS_USE_PKG_CONFIG = true;
    LIBSSH2_SYS_USE_PKG_CONFIG = true;
  };

  postInstall = ''
    installManPage ./git-series.1
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
    maintainers = with maintainers; [
      edef
      vmandela
      aleksana
    ];
    mainProgram = "git-series";
  };
}

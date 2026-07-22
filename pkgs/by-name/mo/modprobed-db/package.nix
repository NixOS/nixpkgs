{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libevdev,
  kmod,
  bash,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "modprobed-db";
  version = "2.50";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "modprobed-db";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JcotyXFrxE9DmrGS8cx/+BvHeQ8rLd+0h4jIYD2NZmY=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    kmod
    libevdev
    bash
  ];

  installFlags = [
    "PREFIX=$(out)"
    "INITDIR_SYSTEMD=$(out)/lib/systemd/user"
  ];

  postPatch = ''
    substituteInPlace ./common/modprobed-db.in \
      --replace "/usr/share" "$out/share"
  '';

  postInstall = ''
    installShellCompletion --zsh common/zsh-completion
  '';

  meta = {
    homepage = "https://github.com/graysky2/modprobed-db";
    description = "Useful utility for users wishing to build a minimal kernel via a make localmodconfig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "modprobed-db";
    platforms = lib.platforms.linux;
  };
})

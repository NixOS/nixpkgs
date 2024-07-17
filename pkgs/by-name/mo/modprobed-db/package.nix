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
let
  pname = "modprobed-db";
  version = "2.47";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "modprobed-db";
    rev = "v${version}";
    hash = "sha256-r/2ZENricRE03eyFnWDnfPNAz2863/9HKlF6a2xOkc0=";
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
}

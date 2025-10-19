{
  lib,
  stdenv,
  fetchFromGitHub,
  m4,
  installShellFiles,
  util-linuxMinimal,
}:

stdenv.mkDerivation rec {
  pname = "dinit";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "davmac314";
    repo = "dinit";
    rev = "v${version}";
    # fix for case-insensitive filesystems
    postFetch = ''
      [ -f "$out/BUILD" ] && rm "$out/BUILD"
    '';
    hash = "sha256-IKT4k2eXCOCXtiypGbsIpN0OHS+WKqXvr4Mb61fbl0M=";
  };

  postPatch = ''
    substituteInPlace src/shutdown.cc \
      --replace-fail '"/bin/umount"' '"${util-linuxMinimal}/bin/umount"' \
      --replace-fail '"/sbin/swapoff"' '"${util-linuxMinimal}/bin/swapoff"'
  '';

  nativeBuildInputs = [
    m4
    installShellFiles
  ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--sbindir=${placeholder "out"}/bin"
  ];

  postInstall = ''
    installShellCompletion --cmd dinitctl \
      --bash contrib/shell-completion/bash/dinitctl \
      --fish contrib/shell-completion/fish/dinitctl.fish \
      --zsh contrib/shell-completion/zsh/_dinit
  '';

  meta = {
    description = "Service manager / supervision system, which can (on Linux) also function as a system manager and init";
    homepage = "https://davmac.org/projects/dinit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aanderse
      lillecarl
    ];
    platforms = lib.platforms.unix;
  };
}

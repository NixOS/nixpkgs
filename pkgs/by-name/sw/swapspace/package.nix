{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  installShellFiles,
  util-linux,
  binlore,
  swapspace,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swapspace";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "Tookmund";
    repo = "Swapspace";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-KrPdmF1H7WFI78ZJlLqDyfxbs7fymSUQpXL+7XjN9bI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
  ];

  postPatch = ''
    substituteInPlace 'swapspace.service' \
      --replace '/usr/local/sbin/' "$out/bin/"
    substituteInPlace 'src/support.c' \
      --replace '/sbin/swapon' '${lib.getBin util-linux}/bin/swapon' \
      --replace '/sbin/swapoff' '${lib.getBin util-linux}/bin/swapoff'
    substituteInPlace 'src/swaps.c' \
      --replace 'mkswap' '${lib.getBin util-linux}/bin/mkswap'

    # Don't create empty directory $out/var/lib/swapspace
    substituteInPlace 'Makefile.am' \
      --replace 'install-data-local:' 'do-not-execute:'
  '';

  postInstall = ''
    installManPage doc/swapspace.8
    install --mode=444 -D 'swapspace.service' "$out/etc/systemd/system/swapspace.service"
  '';

  passthru = {
    # Nothing in swapspace --help or swapspace’s man page mentions
    # anything about swapspace executing its arguments.
    binlore.out = binlore.synthesize swapspace ''
      execer cannot bin/swapspace
    '';
    tests = {
      inherit (nixosTests) swapspace;
    };
  };

  meta = {
    description = "Dynamic swap manager for Linux";
    homepage = "https://github.com/Tookmund/Swapspace";
    changelog = "https://github.com/Tookmund/Swapspace/releases/tag/v${finalAttrs.version}";
    mainProgram = "swapspace";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
})

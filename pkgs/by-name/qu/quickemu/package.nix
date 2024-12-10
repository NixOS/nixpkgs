{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  cdrtools,
  curl,
  gawk,
  glxinfo,
  gnugrep,
  gnused,
  jq,
  ncurses,
  pciutils,
  procps,
  python3,
  qemu_full,
  socat,
  spice-gtk,
  swtpm,
  usbutils,
  util-linux,
  unzip,
  xdg-user-dirs,
  xrandr,
  zsync,
  OVMF,
  OVMFFull,
  quickemu,
  testers,
  installShellFiles,
}:
let
  runtimePaths =
    [
      cdrtools
      curl
      gawk
      gnugrep
      gnused
      jq
      ncurses
      pciutils
      procps
      python3
      qemu_full
      socat
      swtpm
      util-linux
      unzip
      xrandr
      zsync
    ]
    ++ lib.optionals stdenv.isLinux [
      glxinfo
      usbutils
      xdg-user-dirs
    ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "quickemu";
  version = "4.9.5";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "quickemu";
    rev = finalAttrs.version;
    hash = "sha256-UlpNujF2E8H1zcWTen8D29od60pY8FaGueviT0iwupQ=";
  };

  postPatch = ''
    sed -i \
      -e '/OVMF_CODE_4M.secboot.fd/s|ovmfs=(|ovmfs=("${OVMFFull.firmware}","${OVMFFull.variables}" |' \
      -e '/OVMF_CODE_4M.fd/s|ovmfs=(|ovmfs=("${OVMF.firmware}","${OVMF.variables}" |' \
      -e '/cp "''${VARS_IN}" "''${VARS_OUT}"/a chmod +w "''${VARS_OUT}"' \
      -e 's/Icon=.*qemu.svg/Icon=qemu/' \
      -e 's,\[ -x "\$(command -v smbd)" \],true,' \
      quickemu
  '';

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    installManPage docs/quickget.1 docs/quickemu.1 docs/quickemu_conf.1
    install -Dm755 -t "$out/bin" chunkcheck quickemu quickget quickreport windowskey

    # spice-gtk needs to be put in suffix so that when virtualisation.spiceUSBRedirection
    # is enabled, the wrapped spice-client-glib-usb-acl-helper is used
    for f in chunkcheck quickget quickemu quickreport windowskey; do
      wrapProgram $out/bin/$f \
        --prefix PATH : "${lib.makeBinPath runtimePaths}" \
        --suffix PATH : "${lib.makeBinPath [ spice-gtk ]}"
    done

    runHook postInstall
  '';

  passthru.tests = testers.testVersion {
    package = quickemu;
  };

  meta = {
    description = "Quickly create and run optimised Windows, macOS and Linux virtual machines";
    homepage = "https://github.com/quickemu-project/quickemu";
    changelog = "https://github.com/quickemu-project/quickemu/releases/tag/${finalAttrs.version}";
    mainProgram = "quickemu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fedx-sudo
      flexiondotorg
    ];
  };
})

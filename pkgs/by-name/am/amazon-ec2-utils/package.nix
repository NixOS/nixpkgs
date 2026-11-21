{
  lib,
  bash,
  buildPackages,
  coreutils,
  curl,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  nvme-cli,
  python3,
  replaceVars,
  stdenv,
  udevCheckHook,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amazon-ec2-utils";
  version = "2.3.0";

  outputs = [
    "out"
    "tools"
    "man"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "amazonlinux";
    repo = "amazon-ec2-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FrGYiZ7vhXNcCQa3iTb3X4UajqpnMyVD+uDekrJSCi8=";
  };

  postPatch = ''
    substituteInPlace {51-ec2-hvm-devices,70-ec2-nvme-devices}.rules \
      --replace-fail /usr/sbin $out/bin

    # Name EBS volumes with nvme-cli rather than the Python ebsnvme-id.
    substituteInPlace 70-ec2-nvme-devices.rules \
      --replace-fail "ebsnvme-id -u" ebsnvme-bdev

    substituteInPlace 53-ec2-read-ahead-kb.rules \
      --replace-fail /bin/awk ${lib.getExe gawk}
  '';

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    bash
    python3
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin ec2-metadata ec2nvme-nsid ec2udev-vbd
    install -Dm755 ${
      replaceVars ./ebsnvme-bdev.sh {
        logger = lib.getExe' util-linux "logger";
        nvme = lib.getExe nvme-cli;
        timeout = lib.getExe' coreutils "timeout";
      }
    } $out/bin/ebsnvme-bdev
    install -Dm755 -t $tools/bin ebsnvme
    cp -P ebsnvme-id $tools/bin/

    install -Dm644 -t $out/lib/udev/rules.d *.rules

    wrapProgram $out/bin/ec2-metadata \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          curl
          gnused
          util-linux
        ]
      }

    wrapProgram $out/bin/ec2udev-vbd \
      --prefix PATH : ${
        lib.makeBinPath [
          gnugrep
          gnused
        ]
      }

    installManPage doc/*.8

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ udevCheckHook ];

  # We can't run `ec2-metadata` since it calls IMDS even with `--help`.
  installCheckPhase = ''
    runHook preInstallCheck

    $tools/bin/ebsnvme --help
    $tools/bin/ebsnvme-id --help 2>&1 | grep -q 'usage: ebsnvme-id id'

    ${lib.optionalString buildPackages.shellcheck-minimal.compiler.bootstrapAvailable "${lib.getExe buildPackages.shellcheck-minimal} $out/bin/ebsnvme-bdev"}

    # udev runs it without PATH. Reaching nvme-cli, which rejects /dev/null, shows it still works.
    rc=0
    env -i $out/bin/ebsnvme-bdev /dev/null 2> stderr || rc=$?
    [[ $rc == 1 ]]
    grep -q 'Inappropriate ioctl' stderr

    # Feed a copy the lines of `nvme amzn id-ctrl` it reads, still without PATH.
    mkdir fake-nvme
    cat > fake-nvme/nvme <<EOF
    #!/bin/sh
    [ -n "\$HANG" ] && exec ${lib.getExe' coreutils "sleep"} 600
    echo "vid       : \$VID"
    echo "bdev      : \$BDEV"
    EOF
    chmod +x fake-nvme/nvme
    cp $out/bin/ebsnvme-bdev fake-nvme/
    substituteInPlace fake-nvme/ebsnvme-bdev --replace-fail ${lib.getExe nvme-cli} $PWD/fake-nvme/nvme
    bdev() { env -i VID=$1 BDEV=$2 fake-nvme/ebsnvme-bdev /dev/nvme0n1; }
    [[ $(bdev 0x1d0f /dev/xvda) == xvda ]]
    [[ $(bdev 0x1d0f sdf) == sdf ]]
    (! bdev 0x1b36 xvda)
    (! bdev 0x1d0f "")

    # The helper gives up on a hung nvme after the timeout, cut to a second here.
    substituteInPlace fake-nvme/ebsnvme-bdev --replace-fail "timeout 60 " "timeout 1 "
    rc=0
    timeout -s KILL 10 env -i HANG=1 fake-nvme/ebsnvme-bdev /dev/nvme0n1 || rc=$?
    [[ $rc == 124 ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    outputsToInstall = [
      "out"
      "tools"
      "man"
    ];
    description = "Contains a set of utilities and settings for Linux deployments in EC2";
    homepage = "https://github.com/amazonlinux/amazon-ec2-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anthonyroussel
      arianvp
      ketzacoatl
      thefloweringash
    ];
  };
})

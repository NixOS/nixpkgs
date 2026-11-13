{
  lib,
  bash,
  coreutils,
  curl,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  python3,
  stdenv,
  udevCheckHook,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amazon-ec2-utils";
  version = "2.3.0";

  outputs = [
    "out"
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

    install -Dm755 -t $out/bin ebsnvme ec2-metadata ec2nvme-nsid ec2udev-vbd
    cp -P ebsnvme-id $out/bin/

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

    $out/bin/ebsnvme --help
    $out/bin/ebsnvme-id --help 2>&1 | grep -q 'usage: ebsnvme-id id'

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
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

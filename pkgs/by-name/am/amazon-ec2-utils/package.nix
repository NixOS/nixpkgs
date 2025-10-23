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

stdenv.mkDerivation rec {
  pname = "amazon-ec2-utils";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "amazonlinux";
    repo = "amazon-ec2-utils";
    tag = "v${version}";
    hash = "sha256-plTBh2LAXkYVSxN0IZJQuPr7QxD7+OAqHl/Zl8JPCmg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    udevCheckHook
  ];

  buildInputs = [
    bash
    python3
  ];

  installPhase = ''
    mkdir $out

    for file in {ebsnvme-id,ec2-metadata,ec2nvme-nsid,ec2udev-vbd}; do
      install -D -m 755 -t $out/bin "$file"
    done

    wrapProgram $out/bin/ec2-metadata \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          curl
          util-linux
        ]
      }

    wrapProgram $out/bin/ec2nvme-nsid \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
        ]
      }

    wrapProgram $out/bin/ec2udev-vbd \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    for file in *.rules; do
      install -D -m 644 -t $out/lib/udev/rules.d "$file"
    done

    substituteInPlace $out/lib/udev/rules.d/{51-ec2-hvm-devices,70-ec2-nvme-devices}.rules \
      --replace-fail /usr/sbin $out/bin

    substituteInPlace $out/lib/udev/rules.d/53-ec2-read-ahead-kb.rules \
      --replace-fail /bin/awk ${gawk}/bin/awk

    installManPage doc/*.8
  '';

  outputs = [
    "out"
    "man"
  ];

  doInstallCheck = true;

  # We can't run `ec2-metadata` since it calls IMDS even with `--help`.
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/ebsnvme-id --help

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
}

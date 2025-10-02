{
  lib,
  stdenv,
  bash,
  coreutils,
  curl,
  fetchFromGitHub,
  gnugrep,
  gnused,
  installShellFiles,
  iproute2,
  makeBinaryWrapper,
  nix-update-script,
  systemd,
  udevCheckHook,
  util-linuxMinimal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amazon-ec2-net-utils";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "amazonlinux";
    repo = "amazon-ec2-net-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PtnRgNmVrIGndLjYjXWWx85z4oxjn637iZqXd6OSiQg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    udevCheckHook
  ];

  buildInputs = [
    bash
  ];

  # See https://github.com/amazonlinux/amazon-ec2-net-utils/blob/v2.5.4/GNUmakefile#L26-L37.
  installPhase = ''
    runHook preInstall

    mkdir -p $out

    for file in bin/*.sh; do
      install -D -m 755 "$file" $out/bin/$(basename --suffix ".sh" "$file")
      substituteInPlace $out/bin/$(basename --suffix ".sh" "$file") \
        --replace-fail AMAZON_EC2_NET_UTILS_LIBDIR $out/share/amazon-ec2-net-utils
    done

    substituteInPlace $out/bin/setup-policy-routes \
      --replace-fail /lib/systemd ${systemd}/lib/systemd

    wrapProgram $out/bin/setup-policy-routes \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          # bin/setup-policy-roots.sh sources lib/lib.sh which needs these.
          #
          # lib/lib.sh isn't executable so we can't use it with wrapProgram.
          curl
          gnugrep
          gnused
          iproute2
          systemd
          util-linuxMinimal
        ]
      }

    for file in lib/*.sh; do
      install -D -m 644 -t $out/share/amazon-ec2-net-utils "$file"
    done

    substituteInPlace $out/share/amazon-ec2-net-utils/lib.sh \
      --replace-fail /usr/lib/systemd $out/lib/systemd

    for file in udev/*.rules; do
      install -D -m 644 -t $out/lib/udev/rules.d "$file"
    done

    substituteInPlace $out/lib/udev/rules.d/99-vpc-policy-routes.rules \
      --replace-fail /usr/bin/systemctl ${lib.getExe' systemd "systemctl"}

    for file in systemd/network/*.network; do
      install -D -m 644 -t $out/lib/systemd/network "$file"
    done

    for file in systemd/system/*.{service,timer}; do
      install -D -m 644 -t $out/lib/systemd/system "$file"
    done

    substituteInPlace $out/lib/systemd/system/policy-routes@.service \
      --replace-fail /usr/bin/setup-policy-routes $out/bin/setup-policy-routes

    substituteInPlace $out/lib/systemd/system/refresh-policy-routes@.service \
      --replace-fail /usr/bin/setup-policy-routes $out/bin/setup-policy-routes

    installManPage doc/*.8

    runHook postInstall
  '';

  doInstallCheck = true;

  outputs = [
    "out"
    "man"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Contains a set of utilities for managing elastic network interfaces on Amazon EC2";
    homepage = "https://github.com/amazonlinux/amazon-ec2-net-utils";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sielicki ];
  };
})

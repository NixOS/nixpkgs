{
  lib,
  rustPlatform,
  fetchFromGitHub,
  hddtemp,
  hdparm,
  smartmontools,
  nixosTests,
  makeWrapper,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hddfancontrol";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "hddfancontrol";
    tag = finalAttrs.version;
    hash = "sha256-QckNS1IT2GorCYRgVX5B0VY5Rf5U6pHa1uSqzz8ctgE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-drOWc00zqkR2sep1aoAe3urZeA31zM0sUUGW6oDojOM=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postBuild = ''
    mkdir -p target/man
    cargo run --features gen-man-pages -- target/man
  '';

  postInstall = ''
    mkdir -p $out/etc/systemd/system
    substitute systemd/hddfancontrol.service $out/etc/systemd/system/hddfancontrol.service \
      --replace-fail /usr/bin/hddfancontrol $out/bin/hddfancontrol
    sed -i -e '/EnvironmentFile=.*/d' $out/etc/systemd/system/hddfancontrol.service

    cd target/man
    installManPage hddfancontrol-daemon.1 hddfancontrol-pwm-test.1 hddfancontrol.1
  '';

  postFixup = ''
    wrapProgram $out/bin/hddfancontrol \
      --prefix PATH : ${
        lib.makeBinPath [
          hddtemp
          hdparm
          smartmontools
        ]
      }
  '';

  meta = {
    description = "Dynamically control fan speed according to hard drive temperature on Linux";
    changelog = "https://github.com/desbma/hddfancontrol/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/desbma/hddfancontrol";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      benley
      philipwilk
    ];
    mainProgram = "hddfancontrol";
  };
})

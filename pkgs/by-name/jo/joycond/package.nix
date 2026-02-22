{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libevdev,
  udev,
  udevCheckHook,
  acl,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "joycond";
  version = "0.1.0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "DanielOgorchock";
    repo = "joycond";
    rev = "0df025ac5dc284b1f31172b6b252321ba788c4de";
    sha256 = "sha256-2rHSQFQvpNZWZJQenZxPEVkbUFQvhRz1Om1AnnIio4M=";
  };

  passthru.updateScript = unstableGitUpdater {
    branch = "master";
    tagPrefix = "v";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    udevCheckHook
  ];
  buildInputs = [
    libevdev
    udev
  ];

  doInstallCheck = true;

  # CMake has hardcoded install paths
  installPhase = ''
    mkdir -p $out/{bin,etc/{systemd/system,udev/rules.d},lib/modules-load.d}

    cp ./joycond $out/bin
    cp $src/udev/{89,72}-joycond.rules $out/etc/udev/rules.d
    cp $src/systemd/joycond.service $out/etc/systemd/system
    cp $src/systemd/joycond.conf $out/lib/modules-load.d

    substituteInPlace $out/etc/systemd/system/joycond.service --replace \
      "ExecStart=/usr/bin/joycond" "ExecStart=$out/bin/joycond"

    substituteInPlace $out/etc/udev/rules.d/89-joycond.rules --replace \
      "/bin/setfacl"  "${acl}/bin/setfacl"
  '';

  meta = {
    homepage = "https://github.com/DanielOgorchock/joycond";
    description = "Userspace daemon to combine joy-cons from the hid-nintendo kernel driver";
    mainProgram = "joycond";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ TwoUnderscorez ];
    platforms = lib.platforms.linux;
  };
}

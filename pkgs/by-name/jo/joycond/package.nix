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
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "joycond";
  version = "0.1.0-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "DanielOgorchock";
    repo = "joycond";
    rev = "4fe23eed61965e951402520d872ab497c8c93703";
    sha256 = "sha256-R6znMDWZGKrxMyI0R85m4IG1Cal+QWLyRYhncN3I3UE=";
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://github.com/DanielOgorchock/joycond";
    description = "Userspace daemon to combine joy-cons from the hid-nintendo kernel driver";
    mainProgram = "joycond";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ claymorwan ];
    platforms = lib.platforms.linux;
  };
}

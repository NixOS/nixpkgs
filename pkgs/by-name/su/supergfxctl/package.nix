{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  systemd,
  udevCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "supergfxctl";
  version = "5.2.7";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "supergfxctl";
    rev = version;
    hash = "sha256-d3jN4i4oHRFDgr5f6y42gahrCfXBPB61T72x6IeiskM=";
  };

  cargoHash = "sha256-BM/fcXWyEWjAkqOdj2MItOzKknNUe9HMns30H1n5/xo=";

  postPatch = ''
    substituteInPlace data/supergfxd.service --replace /usr/bin/supergfxd $out/bin/supergfxd
    substituteInPlace data/99-nvidia-ac.rules --replace /usr/bin/systemctl ${systemd}/bin/systemctl
  '';

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ systemd ];

  # upstream doesn't have tests, don't build twice just to find that out
  doCheck = false;

  doInstallCheck = true;

  postInstall = ''
    install -Dm444 -t $out/lib/udev/rules.d/ data/*.rules
    install -Dm444 -t $out/share/dbus-1/system.d/ data/org.supergfxctl.Daemon.conf
    install -Dm444 -t $out/lib/systemd/system/ data/supergfxd.service
  '';

  meta = with lib; {
    description = "GPU switching utility, mostly for ASUS laptops";
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.k900 ];
  };
}

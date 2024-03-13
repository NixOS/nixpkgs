{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "supergfxctl";
  version = "5.1.2";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "supergfxctl";
    rev = version;
    hash = "sha256-HJGyjFeN3bq+ArCGfFHAMnjW76wSnNyxPWR0ELcyjLg=";
  };

  cargoSha256 = "sha256-wPqCXbpSYXwsUi1mv9ZBSxdhDgDqsjKxnPzQcURlnDU=";

  postPatch = ''
    substituteInPlace data/supergfxd.service --replace /usr/bin/supergfxd $out/bin/supergfxd
    substituteInPlace data/99-nvidia-ac.rules --replace /usr/bin/systemctl ${systemd}/bin/systemctl
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];

  # upstream doesn't have tests, don't build twice just to find that out
  doCheck = false;

  postInstall = ''
    install -Dm444 -t $out/lib/udev/rules.d/ data/*.rules
    install -Dm444 -t $out/share/dbus-1/system.d/ data/org.supergfxctl.Daemon.conf
    install -Dm444 -t $out/lib/systemd/system/ data/supergfxd.service
  '';

  meta = with lib; {
    description = "A GPU switching utility, mostly for ASUS laptops";
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.k900 ];
  };
}

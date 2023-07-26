{ lib
, rustPlatform
, fetchFromGitLab
, fetchpatch
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "supergfxctl";
  version = "5.1.1";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "supergfxctl";
    rev = version;
    hash = "sha256-AThaZ9dp5T/DtLPE6gZ9qgkw0xksiq+VCL9Y4G41voE=";
  };

  # fix reported version in Cargo.lock
  # submitted upstream: https://gitlab.com/asus-linux/supergfxctl/-/merge_requests/31
  # FIXME: remove for next update
  cargoPatches = [
    (fetchpatch {
      url = "https://gitlab.com/asus-linux/supergfxctl/-/commit/8812dd208791d162881d72f785650a3344ec5151.diff";
      hash = "sha256-eFFj2nIwGXHV1vMIpZvdvFPtfNLDfgqyGRt+VvB03LE=";
    })
  ];

  cargoSha256 = "sha256-gbRGUWfpCQjCxuTdQ+qwOeCDU17G3nNFkIPAgzmeL+E=";

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

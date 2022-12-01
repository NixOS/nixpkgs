{ lib, rustPlatform, fetchFromGitHub, pkg-config, installShellFiles, udev, coreutils }:

rustPlatform.buildRustPackage rec {
  pname = "surface-control";
  version = "0.4.3-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bqrp/XS4OJIRW2ChHnf9gMh/TgCPUEb9fP2soeT1Qe4=";
  };

  cargoSha256 = "sha256-TWXK36cN8WuqfrMX7ybO2lnNiGnSKmfK6QGWMBM1y0o=";

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ udev ];

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/surface-*/out/surface.{bash,fish} \
      --zsh $releaseDir/build/surface-*/out/_surface
    install -Dm 0444 -t $out/etc/udev/rules.d \
      etc/udev/40-surface-control.rules
    substituteInPlace $out/etc/udev/rules.d/40-surface-control.rules \
      --replace "/usr/bin/chmod" "${coreutils}/bin/chmod" \
      --replace "/usr/bin/chown" "${coreutils}/bin/chown"
  '';

  meta = with lib; {
    description =
      "Control various aspects of Microsoft Surface devices on Linux from the Command-Line";
    homepage = "https://github.com/linux-surface/surface-control";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

{ lib, rustPlatform, fetchFromGitHub, installShellFiles, coreutils }:

rustPlatform.buildRustPackage rec {
  pname = "surface-control";
  version = "0.3.1-2";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SLJ4mwBafLGL5pneMTHLc4S4Tgds2xLqByWFH95TK1k=";
  };

  cargoSha256 = "sha256-NH33AMuwf4bOF9zZJlONVMYgrrYSBq5VQClYW/rbzsM=";

  nativeBuildInputs = [ installShellFiles ];

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

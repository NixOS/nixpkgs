{ lib, rustPlatform, fetchFromGitHub, installShellFiles, coreutils }:

rustPlatform.buildRustPackage rec {
  pname = "surface-control";
  version = "0.3.1-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wclzlix0a2naxbdg3wym7yw19p2wqpcjmkf7gn8cs00shrmzjld";
  };

  cargoSha256 = "0vi26v9mvx298kx6k5g7h8dnn7r208an9knadc23vxcrrxjr6pn5";

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
    maintainers = with maintainers; [ winterqt ];
    platforms = platforms.linux;
  };
}

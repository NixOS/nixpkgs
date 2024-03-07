{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, dbus
, libseccomp
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "youki";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BZhg4VhJbAo6XO4w01zguodyr3KEbav+PON0aOmi2bI=";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];

  buildInputs = [ dbus libseccomp systemd ];

  postInstall = ''
    installShellCompletion --cmd youki \
      --bash <($out/bin/youki completion -s bash) \
      --fish <($out/bin/youki completion -s fish) \
      --zsh <($out/bin/youki completion -s zsh)
  '';

  cargoBuildFlags = [ "-p" "youki" ];
  cargoTestFlags = [ "-p" "youki" ];

  cargoHash = "sha256-IkL0gS3hht1XBnOy0YHO02vfw4sljtwfNImfojiLIE4=";

  meta = with lib; {
    description = "A container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    changelog = "https://github.com/containers/youki/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.linux;
    mainProgram = "youki";
  };
}

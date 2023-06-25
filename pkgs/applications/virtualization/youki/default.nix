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
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Nz3paJiR5Jtv8gLBq6mBUyLDfIFJCpnc/RMsDLT09Vg=";
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

  cargoHash = "sha256-luzKyN09lauflAict9zqVdGPbDLFAfe5P8121a5YBsA=";

  meta = with lib; {
    description = "A container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    changelog = "https://github.com/containers/youki/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.linux;
  };
}

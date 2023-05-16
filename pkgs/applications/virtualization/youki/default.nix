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
<<<<<<< HEAD
  version = "0.1.0";
=======
  version = "0.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Nz3paJiR5Jtv8gLBq6mBUyLDfIFJCpnc/RMsDLT09Vg=";
=======
    sha256 = "sha256-00eSXRPy0lQKEabl569gY770viPyB2sEnq1uaT3peE0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  cargoHash = "sha256-luzKyN09lauflAict9zqVdGPbDLFAfe5P8121a5YBsA=";
=======
  cargoSha256 = "sha256-9EgexnsxHxLTXGRbUJZtJEoCeD425zRLfCiIqrXQJkU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    changelog = "https://github.com/containers/youki/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.linux;
  };
}

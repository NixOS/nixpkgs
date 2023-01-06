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
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XwapCfu6Me0xSe+qFz9BFRYpQvG+ztb6QyhGejYRPb4=";
  };

  buildInputs = [ dbus libseccomp systemd ];
  nativeBuildInputs = [ pkg-config installShellFiles ];

  postInstall = ''
    rm $out/bin/integration_test $out/bin/runtimetest
    installShellCompletion --cmd youki \
      --bash <($out/bin/youki completion -s bash) \
      --fish <($out/bin/youki completion -s fish) \
      --zsh <($out/bin/youki completion -s zsh)
  '';

  cargoSha256 = "sha256-xDUTzazNXbH8bNvMnrCok82NVoqRxjyxt4NsEwQrY80=";

  doCheck = false;

  meta = with lib; {
    description = "A container runtime written in Rust";
    homepage = "https://containers.github.io/youki/";
    license = licenses.asl20;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = platforms.linux;
  };
}

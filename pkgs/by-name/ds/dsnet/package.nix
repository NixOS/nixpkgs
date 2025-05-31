{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "dsnet";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "naggie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CKDtILZMWFeSU5nTSguM2fi0BCFdvR2LqELIZ6LYOMk=";
  };

  meta = with lib; {
    description = "Fast command to manage a centralised wireguard VPN. Think wg-quick but quicker: key generation + address allocation";
    homepage = "https://github.com/naggie/dsnet";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ naggie ];
  };

  vendorHash = "sha256-Q2Ipj9yZ+/GUBEmDvgwFLLww7EXnbvdvj/shGQnh1G8=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/dsnet
  '';

  # The ldflags reduce the executable size by stripping some debug stuff.
  # The other variables are set so that the output of dsnet version shows the
  # git ref and the release version from github.
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#discussion_r432097657>
  ldflags = [
    "-w"
    "-s"
    "-X github.com/naggie/dsnet.VERSION=${version}"
    "-X github.com/naggie/dsnet.GIT_COMMIT=v${src.rev}"
  ];

}

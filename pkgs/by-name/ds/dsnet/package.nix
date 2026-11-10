{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "dsnet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "naggie";
    repo = "dsnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oiJ0JAbGkhAQq25lqqz2YyQLrEwPZ6sy7KTa5q3m+/0=";
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
    "-X github.com/naggie/dsnet.VERSION=${finalAttrs.src.tag}"
    "-X github.com/naggie/dsnet.GIT_COMMIT=${finalAttrs.src.tag}"
  ];

  meta = {
    description = "Fast command to manage a centralised Wireguard VPN";
    homepage = "https://github.com/naggie/dsnet";
    changelog = "https://github.com/naggie/dsnet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.naggie ];
    mainProgram = "dsnet";
  };

})

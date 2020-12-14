{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, buildkit
, cni-plugins
, extraPackages ? []
}:

let
  binPath = lib.makeBinPath ([
    buildkit
  ] ++ extraPackages);
in
buildGoModule rec {
  pname = "nerdctl";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bxxdsx8aqbrbjm0bn6makw77z96mng5by7k3licbk0vdgakaix6";
  };

  vendorSha256 = "1d2bqv7bc7q82z6sd8kkqj4xdccs660mj34ggwb09a59law139li";

  nativeBuildInputs = [ makeWrapper ];

  buildFlagsArray = [
    "-ldflags="
    "-w"
    "-s"
    "-X github.com/AkihiroSuda/nerdctl/pkg/version.Version=v${version}"
    "-X github.com/AkihiroSuda/nerdctl/pkg/version.Revision=<unknown>"
  ];

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${binPath}" \
      --prefix CNI_PATH : "${cni-plugins}/bin"
  '';

  meta = with lib; {
    description = "A Docker-compatible CLI for containerd";
    homepage = src.meta.homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jk ];
  };
}

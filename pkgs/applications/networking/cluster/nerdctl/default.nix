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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lSvYiTh67gK9kJls7VsayV8T3H6RzFEEKe49BOWnUBw=";
  };

  vendorSha256 = "sha256-qywiaNoO3pI7sfyPbwWR8BLd86RvJ2xSWwCJUsm3RkM=";

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

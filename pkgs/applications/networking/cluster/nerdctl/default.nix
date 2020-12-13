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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "181qapqgp7zd0imk0zkn4wzpsw292ai2yz9pbiirpjcjx9h26w5h";
  };

  vendorSha256 = "0scywhllxk1m6456wggdmn7sgvy5x3gz2xnyfq9jnvvzap8byr2v";

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

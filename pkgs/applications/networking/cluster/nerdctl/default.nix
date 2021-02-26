{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, buildkit
, cni-plugins
, extraPackages ? [ ]
}:

buildGoModule rec {
  pname = "nerdctl";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zexvTPEQw7iW1d3ahHmqTn+UaT/bJMlr1sVlWErc2ck=";
  };

  vendorSha256 = "sha256-bX1GfKbAbdEAnW3kPNsbF/cJWufxvuhm//G88qJ3u08=";

  nativeBuildInputs = [ makeWrapper ];

  buildFlagsArray = [
    "-ldflags="
    "-w"
    "-s"
    "-X github.com/AkihiroSuda/nerdctl/pkg/version.Version=v${version}"
    "-X github.com/AkihiroSuda/nerdctl/pkg/version.Revision=<unknown>"
  ];

  # Many checks require a containerd socket and running nerdctl after it's built
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${lib.makeBinPath ([ buildkit ] ++ extraPackages)}" \
      --prefix CNI_PATH : "${cni-plugins}/bin"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # nerdctl expects XDG_RUNTIME_DIR to be set
    export XDG_RUNTIME_DIR=$TMPDIR

    $out/bin/nerdctl --help
    # --version will error without containerd.sock access
    $out/bin/nerdctl --help | grep "${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/AkihiroSuda/nerdctl/";
    changelog = "https://github.com/AkihiroSuda/nerdctl/releases/tag/v${version}";
    description = "A Docker-compatible CLI for containerd";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.linux;
  };
}

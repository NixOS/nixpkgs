{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, installShellFiles
, buildkit
, cni-plugins
, extraPackages ? [ ]
}:

buildGoModule rec {
  pname = "nerdctl";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tMzob+ljGBKkfbxwMqy+8bqVp51Eqyx4kXhsj/LRfzQ=";
  };

  vendorSha256 = "sha256-zUX/kneVz8uXmxly8yqmcttK3Wj4EmBaT8gmg3hDms4=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  preBuild = let t = "github.com/AkihiroSuda/nerdctl/pkg/version"; in
    ''
      buildFlagsArray+=("-ldflags" "-s -w -X ${t}.Version=v${version} -X ${t}.Revision=<unknown>")
    '';

  # Many checks require a containerd socket and running nerdctl after it's built
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/nerdctl \
      --prefix PATH : "${lib.makeBinPath ([ buildkit ] ++ extraPackages)}" \
      --prefix CNI_PATH : "${cni-plugins}/bin"

    # nerdctl panics without XDG_RUNTIME_DIR set
    export XDG_RUNTIME_DIR=$TMPDIR

    installShellCompletion --cmd nerdctl \
      --bash <($out/bin/nerdctl completion bash)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nerdctl --help
    $out/bin/nerdctl --version | grep "nerdctl version ${version}"
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

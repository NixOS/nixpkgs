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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "AkihiroSuda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z5Ekryaa5KMShrjdsmFk9bXahtuc+6tec7dxH5/w7+A=";
  };

  vendorSha256 = "sha256-ovmVNtzTQbg141IvbaF/+k5WHxX8wuK7z5gH9l2g5UE=";

  nativeBuildInputs = [ makeWrapper ];

  preBuild =
    let
      t = "github.com/AkihiroSuda/nerdctl/pkg/version";
    in
    ''
      buildFlagsArray+=("-ldflags" "-s -w -X ${t}.Version=v${version} -X ${t}.Revision=<unknown>")
    '';

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

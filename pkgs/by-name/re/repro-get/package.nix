{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  repro-get,
  cacert,
}:

buildGoModule rec {
  pname = "repro-get";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = "repro-get";
    rev = "v${version}";
    sha256 = "sha256-qLu9SZuHCkKAOhzrBPEEev1iD5mcIBvrbXspHtifsq4=";
  };

  vendorHash = "sha256-clpQLRozXFeUGrItL2pfNft2hUNyuyeCP9oMQxagAWs=";

  nativeBuildInputs = [ installShellFiles ];

  # The pkg/version test requires internet access, so disable it here and run it
  # in passthru.pkg-version
  preCheck = ''
    rm -rf pkg/version
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/reproducible-containers/${pname}/pkg/version.Version=v${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd repro-get \
      --bash <($out/bin/repro-get completion bash) \
      --fish <($out/bin/repro-get completion fish) \
      --zsh <($out/bin/repro-get completion zsh)
  '';

  passthru.tests = {
    "pkg-version" = repro-get.overrideAttrs (old: {
      # see invalidateFetcherByDrvHash
      name = "${repro-get.pname}-${
        builtins.unsafeDiscardStringContext (lib.substring 0 12 (baseNameOf repro-get.drvPath))
      }";
      subPackages = [ "pkg/version" ];
      installPhase = ''
        rm -rf $out
        touch $out
      '';
      preCheck = "";
      outputHash = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
      outputHashAlgo = "sha256";
      outputHashMode = "flat";
      outputs = [ "out" ];
      nativeBuildInputs = old.nativeBuildInputs ++ [ cacert ];
    });
    version = testers.testVersion {
      package = repro-get;
      command = "HOME=$(mktemp -d) repro-get -v";
      inherit version;
    };
  };

  meta = with lib; {
    description = "Reproducible apt/dnf/apk/pacman, with content-addressing";
    homepage = "https://github.com/reproducible-containers/repro-get";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "repro-get";
  };
}

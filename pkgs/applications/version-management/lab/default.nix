{ lib, buildGoModule, fetchFromGitHub, makeBinaryWrapper, xdg-utils, installShellFiles, git }:

buildGoModule rec {
  pname = "lab";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "sha256-VCvjP/bSd/0ywvNWPsseXn/SPkdp+BsXc/jTvB11EOk=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-ChysquNuUffcM3qaWUdqu3Av33gnKkdlotEoFKoedA0=";

  doCheck = false;

  nativeBuildInputs = [ makeBinaryWrapper installShellFiles ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    # make xdg-open overrideable at runtime
    wrapProgram $out/bin/lab \
      --prefix PATH ":" "${lib.makeBinPath [ git ]}" \
      --suffix PATH ":" "${lib.makeBinPath [ xdg-utils ]}"
    installShellCompletion --cmd lab \
      --bash <($out/bin/lab completion bash) \
      --fish <($out/bin/lab completion fish) \
      --zsh <($out/bin/lab completion zsh)
  '';

  meta = with lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = "https://zaquestion.github.io/lab";
    license = licenses.cc0;
    maintainers = with maintainers; [ marsam dtzWill SuperSandro2000 ];
  };
}

{ lib, buildGoModule, fetchFromGitHub, makeWrapper, xdg_utils }:

buildGoModule rec {
  pname = "lab";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "0zkwvmzgj7h8lc8jkg2a81392b28c8hkwqzj6dds6q4asbmymx5c";
  };

  subPackages = [ "." ];

  vendorSha256 = "1lrmafvv5zfn9kc0p8g5vdz351n1zbaqwhwk861fxys0rdpqskyc";

  doCheck = false;

  buildInputs = [ makeWrapper ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
    export LAB_CORE_HOST=a LAB_CORE_USER=b LAB_CORE_TOKEN=c
    $out/bin/lab completion bash > $out/share/bash-completion/completions/lab
    $out/bin/lab completion zsh > $out/share/zsh/site-functions/_lab
    wrapProgram $out/bin/lab --prefix PATH ":" "${lib.makeBinPath [ xdg_utils ]}";
  '';

  meta = with lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = "https://zaquestion.github.io/lab";
    license = licenses.cc0;
    maintainers = with maintainers; [ marsam dtzWill ];
  };
}

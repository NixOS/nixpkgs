{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lab";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "1p8q21k8p1zw1g4fn6f7b80r3wziywbm1av1vg7hc8w1rfqj51wp";
  };

  subPackages = [ "." ];

  modSha256 = "1cwj7p03j2bglj379h4hb25kxayx07msz0mnqwwbjv5i3zkc6kkg";

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions" "$out/share/zsh/site-functions"
    export LAB_CORE_HOST=a LAB_CORE_USER=b LAB_CORE_TOKEN=c
    $out/bin/lab completion bash > $out/share/bash-completion/completions/lab
    $out/bin/lab completion zsh > $out/share/zsh/site-functions/_lab
  '';

  meta = with stdenv.lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = https://zaquestion.github.io/lab;
    license = licenses.cc0;
    maintainers = with maintainers; [ marsam dtzWill ];
    platforms = platforms.all;
  };
}

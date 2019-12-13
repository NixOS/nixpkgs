{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lab";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "1z83v1dl9c5f99jvvc23ijkwrfrv489la05rlsrc3r4zzza1hx1f";
  };

  subPackages = [ "." ];

  modSha256 = "03fqa7s6729g0a6ffiyc61dkldpi7vg8pvvpqak4c0mqi1dycivd";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

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

{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lab";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "0f1gi4mlcxjvz2sgh0hzzsqxg5gfvq2ay7xjd0y1kz3pp8kxja7i";
  };

  subPackages = [ "." ];

  modSha256 = "0bw47dd1b46ywsian2b957a4ipm77ncidipzri9ra39paqlv7abb";

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    LAB_CORE_HOST=a LAB_CORE_USER=b LAB_CORE_TOKEN=c \
    $out/bin/lab completion zsh > $out/share/zsh/site-functions/_lab
  '';

  meta = with stdenv.lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = https://zaquestion.github.io/lab;
    license = licenses.unlicense;
    maintainers = with maintainers; [ marsam dtzWill ];
    platforms = platforms.all;
  };
}

{ lib, stdenv, fetchFromGitHub, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "v${version}";
    sha256 = "0jv5b56v75qhdqbrfsddfwizmbizcsv3mn8gp92nckwlx9hrk5id";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake libuuid gnutls ];

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions"
    ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
    mkdir -p "$out/share/fish/vendor_completions.d"
    ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/"
    mkdir -p "$out/share/zsh/site-functions"
    ln -s "../../../share/doc/task/scripts/zsh/_task" "$out/share/zsh/site-functions/"
  '';

  meta = with lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

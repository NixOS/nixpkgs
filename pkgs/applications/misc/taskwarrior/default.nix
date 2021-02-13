{ lib, stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  pname = "taskwarrior";
  version = "2.5.2";

  src = fetchurl {
    url = "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${version}/task-${version}.tar.gz";
    sha256 = "0ipfl9k4l9vls07v64idfvffw68ca1hpv0dv01plmgdryb54bzk3";
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

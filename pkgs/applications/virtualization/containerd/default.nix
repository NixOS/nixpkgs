{ stdenv, fetchFromGitHub, makeWrapper, go, runc, criu }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "07axhrvy45zwnsrvr2618227bzrnqdcjdl7j0mnrhvlryypiic0l";
  };

  buildInputs = [ makeWrapper go ];

  preBuild = ''
    ln -s $(pwd) vendor/src/github.com/docker/containerd
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
    wrapProgram $out/bin/containerd --prefix PATH : "${runc}/bin:${criu}/bin:$out/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://containerd.tools/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}

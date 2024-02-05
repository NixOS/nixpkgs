{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "inotify-info";
  version = "unstable-2024-01-06";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = pname;
    rev = "a7ff6fa62ed96ec5d2195ef00756cd8ffbf23ae1";
    sha256 = "sha256-yY+hjdb5J6dpFkIMMUWvZlwoGT/jqOuQIcFp3Dv+qB8=";
  };

  installPhase = ''
    mkdir -p "$out/bin"
    cp "_release/inotify-info" "$out/bin/"
  '';

  meta = with lib; {
    description = "Easily track down the number of inotify watches, instances, and which files are being watched.";
    homepage = "https://github.com/mikesart/inotify-info";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.motiejus ];
  };
}

{ lib, stdenv, fetchFromGitHub, slurm } :
stdenv.mkDerivation rec {
  pname = "slurm-spank-x11";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "hautreux";
    repo = "slurm-spank-x11";
    rev = version;
    sha256 = "1dmsr7whxcxwnlvl1x4s3bqr5cr6q5ssb28vqi67w5hj4sshisry";
  };

  patches = [ ./hostlist.patch ];

  buildPhase = ''
      gcc -DX11_LIBEXEC_PROG="\"$out/bin/slurm-spank-x11\"" \
          -g -o slurm-spank-x11 slurm-spank-x11.c
      gcc -I${lib.getDev slurm}/include -DX11_LIBEXEC_PROG="\"$out/bin/slurm-spank-x11\"" -shared -fPIC \
          -g -o x11.so slurm-spank-x11-plug.c
    '';

  installPhase = ''
      mkdir -p $out/bin $out/lib
      install -m 755 slurm-spank-x11 $out/bin
      install -m 755 x11.so $out/lib
    '';

  meta = with lib; {
    homepage = "https://github.com/hautreux/slurm-spank-x11";
    description = "Plugin for SLURM to allow for interactive X11 sessions";
    mainProgram = "slurm-spank-x11";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ markuskowa ];
  };
}




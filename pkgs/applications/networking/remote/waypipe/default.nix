{ lib, stdenv, fetchFromGitLab
, meson, ninja, pkg-config, scdoc
, mesa, lz4, zstd, ffmpeg, libva
}:

stdenv.mkDerivation rec {
  pname = "waypipe";
  version = "0.8.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    rev = "v${version}";
    sha256 = "02q8l1qaahmd41h6v3r46akh7xlqz7fpwwsy15qww4jdvypg6vg4";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
  buildInputs = [
    # Optional dependencies:
    mesa lz4 zstd ffmpeg libva
  ];

  meta = with lib; {
    description = "A network proxy for Wayland clients (applications)";
    longDescription = ''
      waypipe is a proxy for Wayland clients. It forwards Wayland messages and
      serializes changes to shared memory buffers over a single socket. This
      makes application forwarding similar to ssh -X feasible.
    '';
    homepage = "https://mstoeckl.com/notes/gsoc/blog.html";
    changelog = "https://gitlab.freedesktop.org/mstoeckl/waypipe/-/releases#v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}

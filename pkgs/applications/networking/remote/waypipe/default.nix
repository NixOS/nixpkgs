{ lib, stdenv, fetchFromGitLab
, meson, ninja, pkg-config, scdoc
, mesa, lz4, zstd, ffmpeg, libva
}:

stdenv.mkDerivation rec {
  pname = "waypipe-unstable";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    rev = "v${version}";
    sha256 = "1qa47ljfvb1vv3h647xwn1j5j8gfmcmdfaz4j8ygnkvj36y87vnz";
  };

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

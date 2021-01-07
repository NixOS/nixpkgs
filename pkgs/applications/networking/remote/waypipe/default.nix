{ stdenv, fetchFromGitLab
, meson, ninja, pkg-config, scdoc
, openssh
, mesa, lz4, zstd, ffmpeg, libva
}:

stdenv.mkDerivation rec {
  pname = "waypipe-unstable";
  version = "0.7.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    rev = "v${version}";
    sha256 = "sha256-LtfrSEwZikOXp/fdyJ/+EylRx19zdsHMkrl1eEf1/aY=";
  };

  postPatch = ''
    substituteInPlace src/waypipe.c \
      --replace "/usr/bin/ssh" "${openssh}/bin/ssh"
  '';

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];

  buildInputs = [
    # Optional dependencies:
    mesa lz4 zstd ffmpeg libva
  ];

  meta = with stdenv.lib; {
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

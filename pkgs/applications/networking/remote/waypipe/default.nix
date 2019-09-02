{ stdenv, fetchFromGitLab
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, openssh
, mesa, lz4, zstd, ffmpeg_4, libva
}:

stdenv.mkDerivation rec {
  pname = "waypipe-unstable";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    rev = "v${version}";
    sha256 = "13kp5snkksli0sj5ldkgybcs1s865f0qdak2w8796xvy8dg9jda8";
  };

  postPatch = ''
    substituteInPlace src/waypipe.c \
      --replace "/usr/bin/ssh" "${openssh}/bin/ssh"
  '';

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];

  buildInputs = [
    wayland wayland-protocols
    # Optional dependencies:
    mesa lz4 zstd ffmpeg_4 libva
  ];

  enableParallelBuilding = true;

  mesonFlags = [ "-Dwerror=false" ]; # TODO: Report warnings upstream

  meta = with stdenv.lib; {
    description = "A network proxy for Wayland clients (applications)";
    longDescription = ''
      waypipe is a proxy for Wayland clients. It forwards Wayland messages and
      serializes changes to shared memory buffers over a single socket. This
      makes application forwarding similar to ssh -X feasible.
    '';
    homepage = https://mstoeckl.com/notes/gsoc/blog.html;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}

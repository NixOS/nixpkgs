{ stdenv, fetchFromGitHub, fetchpatch, clang,
  pkg-config, curl, mpv, yajl }:

stdenv.mkDerivation rec {
  pname = "jftui";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Aanok";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g93w8ahyh2v0cv2fyj5a7v6qyznavwk0dcxx1qw4kczdgmlxnkx";
  };

  patches = [
    # Remove this patch with next version
    (fetchpatch {
      name = "curl-capability-check-fix";
      url = "https://github.com/Aanok/jftui/commit/d63996b8bc0d2ac4b04c5de4169bc7f8ec9b2a30.patch";
      sha256 = "1d595mkzgx3carq2cykxpvmf5klgdlyaq94fk9wj8812yswqlsr7";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    clang
    curl
    mpv
    yajl
  ];

  installPhase = ''
    install -Dm555 build/jftui $out/bin/jftui
  '';

  meta = with stdenv.lib; {
    description = "Jellyfin Terminal User Interface ";
    homepage = "https://github.com/Aanok/jftui";
    license = licenses.unlicense;
    maintainers = [ maintainers.nyanloutre ];
    platforms = platforms.linux;
  };
}

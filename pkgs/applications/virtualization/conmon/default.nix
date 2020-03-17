{ stdenv
, fetchFromGitHub
, pkg-config
, glib
, glibc
, systemd
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vf88j582hv6dabmk3pnmbn60pp5w7hja2wmrhqq8wm2y07djhhi";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib systemd ] ++
    stdenv.lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  installPhase = "install -Dm755 bin/${pname} $out/bin/${pname}";

  meta = with stdenv.lib; {
    homepage = "https://github.com/containers/conmon";
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester saschagrunert ];
    platforms = platforms.linux;
  };
}

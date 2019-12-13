{ stdenv
, fetchFromGitHub
, pkgconfig
, glib
, glibc
, systemd
}:

stdenv.mkDerivation rec {
  project = "conmon";
  name = "${project}-${version}";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "containers";
    repo = project;
    rev = "v${version}";
    sha256 = "1sfh94a1if907kky0wlqz188v6kfdl6v1i34pikpxjllngxzyfr9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib systemd ] ++
    stdenv.lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  installPhase = "install -Dm755 bin/${project} $out/bin/${project}";

  meta = with stdenv.lib; {
    homepage = https://github.com/containers/conmon;
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester saschagrunert ];
    platforms = platforms.linux;
  };
}

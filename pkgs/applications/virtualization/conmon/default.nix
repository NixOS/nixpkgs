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
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "containers";
    repo = project;
    rev = "v${version}";
    sha256 = "194wach3yrkvll2xaj0x77hzlngk2016mflgnd5k8knjn2b9dgvl";
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssss";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "MrJoy";
    repo = "ssss";
    rev = "releases%2Fv${finalAttrs.version}";
    sha256 = "18r1hwch6nq6gjijavr4pvrxz2plrlrvdx8ssqhdj2vmqvlqwbvd";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    gmp
  ];

  preBuild = ''
    sed -e s@/usr/@$out/@g -i Makefile
    cp ssss.manpage.xml ssss.1
    mkdir -p $out/bin
    echo -e 'install:\n\tcp ssss-combine ssss-split '"$out"'/bin' >>Makefile
  '';

  postInstall = ''
    installManPage ssss.1
  '';

  meta = {
    description = "Shamir Secret Sharing Scheme";
    homepage = "http://point-at-infinity.org/ssss/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

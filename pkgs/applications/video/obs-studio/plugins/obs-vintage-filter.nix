{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-vintage-filter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cg2121";
    repo = "obs-vintage-filter";
    rev = version;
    sha256 = "sha256-K7AxvwVLe4G+75aY430lygSRB7rMtsGi17pGzdygEac=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "OBS Studio filter where the source can be set to be black & white or sepia";
    homepage = "https://github.com/cg2121/obs-vintage-filter";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}

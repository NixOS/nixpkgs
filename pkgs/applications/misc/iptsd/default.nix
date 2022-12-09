{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, systemd, inih }:

stdenv.mkDerivation rec {
  pname = "iptsd";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-du5TC3I5+hWifjdnaeTj2QPJ6/oTXZqaOrZJkef/USU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ systemd inih ];

  # Original installs udev rules and service config into global paths
  postPatch = ''
    substituteInPlace meson.build \
      --replace "install_dir: unitdir" "install_dir: datadir" \
      --replace "install_dir: rulesdir" "install_dir: datadir" \
  '';
  mesonFlags = [
    "-Dservice_manager=systemd"
    "-Dsample_config=false"
    "-Ddebug_tool=false"
  ];

  meta = with lib; {
    description = "Userspace daemon for Intel Precise Touch & Stylus";
    homepage = "https://github.com/linux-surface/iptsd";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ tomberek ];
    platforms = platforms.linux;
  };
}

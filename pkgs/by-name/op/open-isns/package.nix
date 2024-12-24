{
  lib,
  stdenv,
  pkg-config,
  meson,
  ninja,
  openssl,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "open-isns";
  version = "0.103";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "open-isns";
    rev = "v${version}";
    sha256 = "sha256-buqQMsoxRCbWiBDq0XAg93J7bjbdxeIernV8sDVxCAA=";
  };

  # The location of /var/lib is not made configurable in the meson.build file
  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "/var/lib" "$out/var/lib" \
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  propagatedBuildInputs = [ openssl ];
  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  configureFlags = [ "--enable-shared" ];

  mesonFlags = [
    "-Dslp=disabled" # openslp is not maintained and labeled unsafe
    "-Dsystemddir=${placeholder "out"}/lib/systemd"
  ];

  meta = with lib; {
    description = "iSNS server and client for Linux";
    license = licenses.lgpl21Only;
    homepage = "https://github.com/open-iscsi/open-isns";
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}

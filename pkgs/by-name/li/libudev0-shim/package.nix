{
  lib,
  stdenv,
  fetchFromGitHub,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "libudev0-shim";
  version = "1";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "libudev0-shim";
    rev = "v${version}";
    sha256 = "1460qm6rp1cqnns39lj24z7191m8sbpvbjabqbzb55dkdd2kw50z";
  };

  buildInputs = [ udev ];

  installPhase = ''
    name="$(echo libudev.so.*)"
    install -Dm755 "$name" "$out/lib/$name"
    ln -s "$name" "$out/lib/libudev.so.0"
  '';

  meta = with lib; {
    description = "Shim to preserve libudev.so.0 compatibility";
    homepage = "https://github.com/archlinux/libudev0-shim";
    platforms = platforms.linux;
    license = licenses.lgpl21;
    maintainers = [ ];
  };
}

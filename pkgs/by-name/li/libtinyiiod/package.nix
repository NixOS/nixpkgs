{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libtinyiiod";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libtinyiiod";
    tag = "v${version}";
    hash = "sha256-SfgArxiIQG5dPBsb2vOaJKqzmc/jwDxaKQ/hO8A2it4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny IIO daemon implementation";
    homepage = "https://github.com/analogdevicesinc/libtinyiiod";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}

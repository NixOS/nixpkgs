{ lib, stdenv, fetchFromGitHub, pkg-config, hidapi }:

stdenv.mkDerivation {
  pname = "footswitch";
  version = "unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = "footswitch";
    rev = "b7493170ecc956ac87df2c36183253c945be2dcf";
    sha256 = "sha256-vwjeWjIXQiFJ0o/wgEBrKP3hQi8Xa/azVS1IE/Q/MyY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ hidapi ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local $out \
      --replace-fail /usr/bin/install install \
      --replace-fail /etc/udev $out/lib/udev
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/udev/rules.d
  '';

  meta = with lib; {
    description = "Command line utlities for programming PCsensor and Scythe foot switches";
    homepage = "https://github.com/rgerganov/footswitch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ baloo ];
  };
}

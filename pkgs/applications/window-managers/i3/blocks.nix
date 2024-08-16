{ fetchFromGitHub, fetchpatch, lib, stdenv, autoreconfHook, pkg-config }:

stdenv.mkDerivation {
  pname = "i3blocks";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "3417602a2d8322bc866861297f535e1ef80b8cb0";
    sha256 = "0v8mwnm8qzpv6xnqvrk43s4b9iyld4naqzbaxk4ldq1qkhai0wsv";
  };

  patches = [
    # XDG_CONFIG_DIRS can contain multiple elements separated by colons, which should be searched in order.
    (fetchpatch {
      # https://github.com/vivien/i3blocks/pull/405
      url = "https://github.com/edef1c/i3blocks/commit/d57b32f9a364aeaf36869efdd54240433c737e57.patch";
      sha256 = "102xb0ax0hmg82dz2gzfag470dkckzf2yizai0izacvrz0d3ngj1";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Flexible scheduler for your i3bar blocks";
    mainProgram = "i3blocks";
    homepage = "https://github.com/vivien/i3blocks";
    license = licenses.gpl3;
    platforms = with platforms; freebsd ++ linux;
  };
}

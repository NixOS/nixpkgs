{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "60";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = "inih";
    rev = "r${version}";
    hash = "sha256-6U6/b7J4dGFwVPw31Vl+BEDrN2ygK43Hb344Uk8NdFs=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Simple .INI file parser in C, good for embedded systems";
    homepage = "https://github.com/benhoyt/inih";
    changelog = "https://github.com/benhoyt/inih/releases/tag/r${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ TredwellGit ];
    platforms = lib.platforms.all;
  };
}

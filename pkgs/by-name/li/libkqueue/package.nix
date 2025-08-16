{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libkqueue";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "mheily";
    repo = "libkqueue";
    rev = "v${version}";
    sha256 = "sha256-q9ycYeo8BriD9bZEozjkdHUg2xntQUZwbYX7d1IZPzk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "kqueue(2) compatibility library";
    homepage = "https://github.com/mheily/libkqueue";
    changelog = "https://github.com/mheily/libkqueue/raw/v${version}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}

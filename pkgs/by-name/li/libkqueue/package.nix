{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkqueue";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "mheily";
    repo = "libkqueue";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-q9ycYeo8BriD9bZEozjkdHUg2xntQUZwbYX7d1IZPzk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "kqueue(2) compatibility library";
    homepage = "https://github.com/mheily/libkqueue";
    changelog = "https://github.com/mheily/libkqueue/raw/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

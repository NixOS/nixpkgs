{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmic";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qmic";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-0/mIg98pN66ZaVsQ6KmZINuNfiKvdEHMsqDx0iciF8w=";
  };

  installFlags = [ "prefix=$(out)" ];

  meta = {
    maintainers = with lib.maintainers; [ matthewcroughan ];
    description = "QMI IDL compiler";
    homepage = "https://github.com/andersson/qmic";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.aarch64;
  };
})

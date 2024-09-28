{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  libplist,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libimobiledevice-glue";
  version = "1.3.0-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libimobiledevice-glue";
    rev = "362f7848ac89b74d9dd113b38b51ecb601f76094";
    hash = "sha256-+poCrn2YHeH8RQCfWDdnlmJB4Nf+unWUVwn7YwILHIs=";
  };

  outputs = [
    "out"
    "dev"
  ];
  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libplist
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libimobiledevice-glue";
    description = "Library with common code used by the libraries and tools around the libimobiledevice project";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  bluez,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redfang";
  version = "2.5";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "redfang";
    rev = "upstream/${finalAttrs.version}";
    hash = "sha256-dF9QmBckyHAZ+JbLr0jTmp0eMu947unJqjrTMsJAfIE=";
  };

  patches = [
    # make install rule
    (fetchpatch {
      url = "https://gitlab.com/kalilinux/packages/redfang/-/merge_requests/1.diff";
      sha256 = "sha256-oxIrUAucxsBL4+u9zNNe2XXoAd088AEAHcRB/AN7B1M=";
    })
    # error: implicit declaration of function 'pthread_create' []
    ./include-pthread.patch
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  buildInputs = [ bluez ];

  meta = {
    description = "Small proof-of-concept application to find non discoverable bluetooth devices";
    homepage = "https://gitlab.com/kalilinux/packages/redfang";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ moni ];
    mainProgram = "fang";
  };
})

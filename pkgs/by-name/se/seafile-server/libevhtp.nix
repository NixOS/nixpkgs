{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libevhtp";
  version = "0-unstable-2021-04-28";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libevhtp";
    rev = "18c649203f009ef1d77d6f8301eba09af3777adf";
    hash = "sha256-LcZu46NxY7rJNMNqo3/x7SMGExL7OTjvXxI5KjyTwOU=";
  };

  # This fork vendors a 2014-era oniguruma whose hash table API declares
  # unprototyped function pointers (`int (*compare)();` in oniguruma/st.h, plus
  # ANYARGS expanding to nothing). Under -std=gnu23, which GCC 14+ defaults to,
  # `()` means "takes no arguments", so every call through those pointers is an
  # error rather than a warning.
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libevent ];

  cmakeFlags = [
    "-DEVHTP_DISABLE_SSL=ON"
    "-DEVHTP_BUILD_SHARED=ON"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    description = "Create extremely-fast and secure embedded HTTP servers with ease";
    homepage = "https://github.com/criticalstack/libevhtp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ philocalyst ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  pcre2,
  python3,
  openssl,
  cmake,
  pkg-config,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "3proxy";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "3proxy";
    repo = "3proxy";
    tag = finalAttrs.version;
    sha256 = "sha256-hLxafFU6nJ3I3NT3R24LPD7PBmQ1IZEbrVqvfmMZHIM=";
  };

  buildInputs = [
    pcre2
    openssl
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    python3 ../tests/run.py -v
    runHook postCheck
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail " /Library" " Library" \
      --replace-fail " /etc" " etc" \
      --replace-fail " /opt" " opt" \
      --replace-fail "/usr" "usr"
  '';

  passthru.tests = {
    smoke-test = nixosTests._3proxy;
  };

  meta = {
    description = "Tiny free proxy server";
    homepage = "https://github.com/3proxy/3proxy";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
